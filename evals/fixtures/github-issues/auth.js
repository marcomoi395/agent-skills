// Authentication module for user login
// Issue: Authentication times out after 5 seconds instead of configured 30 seconds

const API_TIMEOUT = 30000; // 30 seconds

async function authenticateUser(username, password) {
  try {
    // BUG: Hardcoded timeout of 5000ms ignores API_TIMEOUT constant
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
      signal: AbortSignal.timeout(5000) // Should use API_TIMEOUT
    });

    if (!response.ok) {
      throw new Error(`Auth failed: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    if (error.name === 'TimeoutError') {
      console.error('Authentication timed out');
      // Users on slow connections see this error even though server responds within 30s
    }
    throw error;
  }
}

module.exports = { authenticateUser };
