# HAJIFUND Security Configuration

This directory contains security-sensitive configuration files that should **NEVER** be committed to version control.

## 🔐 Files in this Directory

### Credential Files (⚠️ NEVER COMMIT)
- `test_credentials.json` - Test user credentials and API endpoints
- `api_config.dart` - API configuration with environment-specific settings
- `secrets.json` - Production secrets (if created)
- `database.json` - Database connection strings (if created)

### Template Files (✅ Safe to commit)
- `environment.example` - Template for environment variables
- `README.md` - This security documentation

## 🛡️ Security Best Practices

### 1. Environment Variables
For production deployments, use environment variables instead of config files:

```bash
# Example production environment variables
export API_BASE_URL="https://api.hajifund.com/api/v1"
export JWT_SECRET="your-super-secret-jwt-key"
export DATABASE_URL="postgresql://user:pass@host:5432/db"
```

### 2. Local Development Setup

1. **Copy the template:**
   ```bash
   cp config/environment.example .env
   ```

2. **Fill in your local values:**
   ```bash
   # Edit .env with your actual development credentials
   nano .env
   ```

3. **Never commit .env files:**
   ```bash
   # .env is already in .gitignore
   git status  # Should not show .env files
   ```

### 3. Test Credentials Management

The `test_credentials.json` file contains:
- Test user accounts with secure passwords
- API endpoint configurations
- Cooperative test data

**Usage:**
```bash
# Use the secure test script
./scripts/test_with_secure_credentials.sh
```

### 4. API Configuration

The `api_config.dart` file provides:
- Environment-specific API URLs
- Timeout configurations
- Security settings
- Debug options

**Environment Detection:**
```dart
// Automatically detects environment
String apiUrl = ApiConfig.baseUrl;  // Uses appropriate URL
bool isDebug = ApiConfig.enableDebugMode;  // Only true in development
```

## 🚨 Security Warnings

### ❌ NEVER DO THIS:
```dart
// DON'T hardcode credentials in source code
const String password = "MyPassword123!";
const String apiKey = "sk_live_abc123...";
```

### ✅ DO THIS INSTEAD:
```dart
// Use environment variables
const String? apiKey = String.fromEnvironment('API_KEY');
// Or load from secure storage
final password = await secureStorage.read(key: 'user_password');
```

## 🔧 Configuration Management

### Development Environment
1. Use `config/test_credentials.json` for local testing
2. Set environment variables for sensitive data
3. Use `ApiConfig.developmentBaseUrl` for local API

### Staging Environment
1. Use environment variables exclusively
2. Enable SSL certificate pinning
3. Set `ENVIRONMENT=staging`

### Production Environment
1. **ALL** secrets must be environment variables
2. Enable all security features
3. Set `ENVIRONMENT=production`
4. Use secure key management services (AWS KMS, Azure Key Vault, etc.)

## 📋 Checklist Before Deployment

- [ ] All credentials moved to environment variables
- [ ] No hardcoded secrets in source code
- [ ] `.env` files added to `.gitignore`
- [ ] Test credentials file not committed
- [ ] SSL/TLS enabled for all environments
- [ ] API keys have appropriate permissions only
- [ ] Database credentials use least-privilege principle
- [ ] Monitoring and alerting configured
- [ ] Backup and recovery procedures tested

## 🆘 If Credentials Are Accidentally Committed

1. **Immediately revoke/rotate all exposed credentials**
2. **Remove from git history:**
   ```bash
   # Remove sensitive file from git history
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch config/secrets.json' \
   --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push to all branches**
4. **Notify team members to pull latest changes**
5. **Update all deployment environments with new credentials**

## 📞 Security Contact

For security-related issues or questions:
- **Security Team**: security@hajifund.com
- **Emergency**: +62-xxx-xxx-xxxx
- **Incident Response**: Follow the incident response playbook

---

**Remember: Security is everyone's responsibility! 🛡️**
