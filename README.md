# Vibes API

Vibes API is a Ruby on Rails application designed to provide robust and secure data management for the Vibes app, featuring user management, secure data storage, and automated testing.

## Overview

- **User Management**: Admins can manage user roles and permissions.
- **Secure Data Storage**: All sensitive data is encrypted and securely stored.
- **Automated Testing**: CI/CD pipeline runs tests automatically on new commits.

## Getting Started

### Prerequisites

- Ruby 3.1 
- Rails 7
- Bundler
- PostgreSQL 
### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Bluette1/vibes-api.git
   cd vibes-api
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Set up the database**:

   ```bash
   rake db:create db:migrate
   ```

4. **Run the application**:
   ```bash
   rails server
   ```

### Running Tests

Execute the test suite using Rake:

```bash
bundle exec rake test
```

### Code Style

Ensure code style consistency with RuboCop:

```bash
bundle exec rubocop
```

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch.
5. Open a pull request.


**View user stories:** [https://www.notion.so/User-Stories-Vibes-11fe6a4d98f280c98b15d37c90890c0e?pvs=4](https://www.notion.so/User-Stories-Vibes-11fe6a4d98f280c98b15d37c90890c0e?pvs=21)

## License

This project is licensed under the MIT License.
