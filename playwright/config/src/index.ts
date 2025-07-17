// Simple config loader for Playwright - matches Jest pattern
const configPath = process.env.PLAYWRIGHT_CONFIG;
const rootPath = process.env.PLAYWRIGHT_ROOT!;

const config = configPath ? require(configPath) : {};

// Export the config for Playwright to use
module.exports = config;
