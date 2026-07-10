// Simple script to check logs in localStorage
const fs = require('fs');
const path = require('path');

// Path to localStorage file (this is just an example, actual path may vary)
const localStoragePath = path.join(process.env.LOCALAPPDATA, 'Google', 'Chrome', 'User Data', 'Default', 'Local Storage');

console.log('LocalStorage path:', localStoragePath);

// Check if the directory exists
if (fs.existsSync(localStoragePath)) {
  // List files in the directory
  const files = fs.readdirSync(localStoragePath);
  console.log('Files in localStorage directory:', files);
} else {
  console.log('LocalStorage directory not found');
}

// Alternatively, let's check the logger implementation
console.log('\nLogger implementation:');
const loggerPath = path.join(__dirname, 'src', 'utils', 'logger.ts');
if (fs.existsSync(loggerPath)) {
  const loggerContent = fs.readFileSync(loggerPath, 'utf8');
  console.log('Logger class found and implemented');
  console.log('Logger methods:', loggerContent.match(/public static \w+/g)?.join(', '));
} else {
  console.log('Logger file not found');
}
