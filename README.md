# Rails Starter App

Tyler's best practices for Ruby on Rails development with Cursor, codified in a starter Rails app that includes a comprehensive guide called [Tyler's Guide to Writing Rails Apps That Outlive Empires](TYLERSGUIDE.md).

I recently got into developing with Cursor and decided to create my own concise, complete guide to feed into the model as context. Sharing in case others find it useful.

You may not agree with these guidelines - that's ok! Fork the project and do it your way. Let me know if you do! I'd love to read it.

## 🎯 Purpose

This starter app implements the battle-tested principles and patterns outlined in the guide, including:
  * Coding style
  * General Architecture
  * Recommended Gems
  * Multitenancy
  * Model Classes & recommended patterns
  * Controller Classes & recommended patterns
  * Views with ERb
  * UI code 
  * Testing 
  * Database design
  * Worker queues
  * File uploads
  * Data import
  * Customer support
  * Automated Builds
  * APIs
  * Authorization & Authentication
  * Hosting and Deployment

Yes, the guidelines are opinionated, and yes, they do deviate from the received wisdom of the Ruby on Rails community in certain areas. This is mostly a selfish endeavor to make it easier for me to develop Rails with Cursor in a way that makes sense to me. 

## 🚀 Getting Started

### Prerequisites

- macOS (tested on macOS 22.6.0)
- [asdf](https://asdf-vm.com/) for Ruby version management
- PostgreSQL

### Installation Steps

1. **Install Ruby 3.3.4 with asdf**
   ```bash
   # Install asdf if you haven't already
   brew install asdf

   # Add asdf to your shell
   echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
   source ~/.zshrc

   # Install Ruby 3.3.4
   asdf plugin add ruby
   asdf install ruby 3.3.4
   asdf global ruby 3.3.4 

   # Install Node.js and npm
   asdf plugin add nodejs
   asdf install nodejs 20.11.1
   asdf global nodejs 20.11.1
   ```

2. **Install PostgreSQL**
   ```bash
   brew install postgresql@14
   brew services start postgresql@14
   ```

3. **Clone and Setup**
   ```bash
   # Clone the repository
   git clone https://github.com/tb0yd/rails_starter
   cd rails_starter

   # Install dependencies
   bundle install

   # Create and setup the database
   bundle exec rails db:create db:migrate
   ```

4. **Run Tests**
   ```bash
   bundle exec rspec
   ```

## 🛠 Development

### Running the Server
```bash
bundle exec rails server
```

```bash
npm run build
```

## 📚 Additional Resources

- [Tyler's Guide to Writing Rails Apps That Outlive Empires](GUIDE.md)
- [Ruby on Rails Guides](https://guides.rubyonrails.org/v7.1/index.html)
- [RSpec Documentation](https://rspec.info/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🤝 Contributing

This repo is *open* for contribution. And forking! 

If you like the guidelines, but see some things that need tweaking, feel free to open a pull request. You have to be on board with the guidelines in general, though.

If you don't like the guidelines, but like the overall idea and format of the project, feel free to fork and make your own. Send me a link to your own starter project, and I'll link you here! :-D
