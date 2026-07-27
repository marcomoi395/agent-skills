/**
 * agent-skills session start hook for oh-my-pi
 * 
 * Injects the using-agent-skills meta-skill into every new session.
 * This ensures agents have access to the skill discovery flowchart from the start.
 */
import type { HookAPI } from "@oh-my-pi/pi-coding-agent";
import * as path from "node:path";

export default function (pi: HookAPI) {
	pi.on("session_start", async (_event, ctx) => {
		// Resolve the meta-skill path relative to this hook file
		// For oh-my-pi: hook is in .omp/hooks/, skills are in .omp/skills/ (symlink)
		// For standalone: hook is in hooks/, skills are in skills/
		const hookDir = path.dirname(new URL(import.meta.url).pathname);
		const metaSkillPath = path.join(hookDir, "..", "skills", "using-agent-skills", "SKILL.md");

		try {
			// Use Bun.file for file operations (omp runs on Bun)
			const file = Bun.file(metaSkillPath);

			if (!(await file.exists())) {
				pi.logger.info(
					"agent-skills: using-agent-skills meta-skill not found. Skills may still be available individually."
				);
				if (ctx.hasUI) {
					ctx.ui.notify(
						"agent-skills: meta-skill not found. Skills remain available individually.",
						"info"
					);
				}
				return;
			}

			const content = await file.text();

			// Inject the meta-skill content into the session
			// This message participates in LLM context and is visible in the TUI
			pi.sendMessage({
				customType: "agent-skills-meta",
				content: `agent-skills loaded. Use the skill discovery flowchart to find the right skill for your task.

${content}`,
				display: true,
				attribution: "agent", // System-provided context
			});

			pi.logger.info("agent-skills: meta-skill loaded successfully");
		} catch (error) {
			pi.logger.error(`agent-skills: Failed to load meta-skill: ${error}`);
			if (ctx.hasUI) {
				ctx.ui.notify(
					"agent-skills: Failed to load meta-skill. Skills may still be available individually.",
					"warning"
				);
			}
		}
	});
}
