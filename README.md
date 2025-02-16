# AI Developer's Launch Pad 🚀

A cutting-edge, full-stack starter template built on Next.js, MongoDB, and Auth0 designed to get your ideas off the ground—fast.

![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white)
![Auth0](https://img.shields.io/badge/Auth0-EB5424?style=for-the-badge&logo=auth0&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

## Overview

AI Developer's Launch Pad is your foundation for building modern web applications. It combines the power of Next.js 14's App Router, MongoDB's flexible document database, and Auth0's enterprise-grade authentication into a cohesive, production-ready template.

## ✨ Features

- 🎯 **Next.js 14 App Router** - Server components and modern routing
- 🔐 **Auth0 Authentication** - Secure, scalable user management
- 📚 **MongoDB + Mongoose** - Type-safe database operations
- 🎨 **Tailwind CSS** - Beautiful, responsive design with dark mode
- 📱 **Dashboard & Team Management** - Ready-to-use admin interface
- 🔑 **API Key Management** - Secure API access control
- 🧪 **Testing Suite** - Jest & React Testing Library
- 🐳 **Docker Support** - Production-ready containerization
- 📝 **TypeScript** - Full type safety
- 🛠️ **Developer Tools** - ESLint, Prettier, Husky

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/rom-developers/ai-devs-launchpad.git
cd ai-devs-launchpad

# Install dependencies
npm install

# Configure environment
cp .env.example .env.local
# Fill in your Auth0 and MongoDB credentials

# Start development server
npm run dev
```

Visit `http://localhost:3000` to see your application.

## 🏗️ Project Structure

```
src/
├── app/                    # Next.js App Router pages
│   ├── api/               # API routes
│   ├── dashboard/         # Dashboard pages
│   └── (auth)/           # Auth-related pages
├── components/            # React components
│   ├── ui/               # Reusable UI components
│   └── features/         # Feature-specific components
├── lib/                  # Utilities and models
│   ├── models/          # Mongoose models
│   └── utils/           # Helper functions
└── styles/              # Global styles
```

## 🔐 Key Features

### Authentication
- Secure Auth0 integration
- Social provider support
- JWT token handling
- Protected routes

### Database
- MongoDB connection pooling
- Type-safe Mongoose models
- Automatic timestamps
- Indexed collections

### Dashboard
- Real-time statistics
- Team management
- API key management
- Dark mode support
- Responsive design

## 🧪 Development

```bash
# Run tests
npm test

# Check code style
npm run lint

# Format code
npm run format

# Build for production
npm run build
```

## 🐳 Deployment

### Docker

```bash
# Build image
docker build -t ai-devs-launchpad .

# Run container
docker run -p 3000:3000 ai-devs-launchpad
```

### Development with Docker Compose

```bash
# Start development environment
docker-compose up
```

## 📚 Documentation

- [Getting Started](docs/getting-started.md)
- [Authentication](docs/authentication.md)
- [Database](docs/database.md)
- [Deployment](docs/deployment.md)
- [Testing](docs/testing.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Next.js](https://nextjs.org/)
- [MongoDB](https://www.mongodb.com/)
- [Auth0](https://auth0.com/)
- [Tailwind CSS](https://tailwindcss.com/)

---

Built with ❤️ by [Rom Iluz](https://github.com/rom-developers)
