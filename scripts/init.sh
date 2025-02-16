#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initializing AI Developer's Launch Pad...${NC}"

# Function to prompt for input with default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    echo -e "${BLUE}$prompt ${NC}(default: $default):"
    read value
    echo "${value:-$default}"
}

# Get project information
echo -e "\n${GREEN}Project Setup${NC}"
PROJECT_NAME=$(prompt_with_default "Project name" "my-awesome-app")
PROJECT_DESCRIPTION=$(prompt_with_default "Project description" "Built with AI Developer's Launch Pad")
AUTHOR_NAME=$(git config user.name || echo "Your Name")
AUTHOR_NAME=$(prompt_with_default "Author name" "$AUTHOR_NAME")
AUTHOR_EMAIL=$(git config user.email || echo "your.email@example.com")
AUTHOR_EMAIL=$(prompt_with_default "Author email" "$AUTHOR_EMAIL")
GITHUB_USERNAME=$(prompt_with_default "GitHub username" "yourusername")

# Verify MongoDB URI
echo -e "\n${GREEN}MongoDB Setup${NC}"
if [ -f .env.local ]; then
    MONGODB_URI=$(grep MONGODB_URI .env.local | cut -d '=' -f2)
    if [ -z "$MONGODB_URI" ]; then
        echo -e "${RED}Warning: MONGODB_URI not found in .env.local${NC}"
        MONGODB_URI=$(prompt_with_default "MongoDB URI" "mongodb://localhost:27017/myapp")
        echo "MONGODB_URI=$MONGODB_URI" >> .env.local
    fi
else
    echo -e "${BLUE}Creating .env.local from example...${NC}"
    cp .env.example .env.local
    MONGODB_URI=$(prompt_with_default "MongoDB URI" "mongodb://localhost:27017/myapp")
    echo "MONGODB_URI=$MONGODB_URI" >> .env.local
fi

# Verify Auth0 Configuration
echo -e "\n${GREEN}Auth0 Setup${NC}"
if [ -f .env.local ]; then
    # Check for required Auth0 variables
    AUTH0_VARS=(
        "AUTH0_SECRET"
        "AUTH0_BASE_URL"
        "AUTH0_ISSUER_BASE_URL"
        "AUTH0_CLIENT_ID"
        "AUTH0_CLIENT_SECRET"
        "AUTH0_SCOPE"
        "AUTH0_AUDIENCE"
        "NEXT_PUBLIC_AUTH0_DOMAIN"
        "NEXT_PUBLIC_AUTH0_CLIENT_ID"
    )

    MISSING_VARS=()
    for var in "${AUTH0_VARS[@]}"; do
        if ! grep -q "^$var=" .env.local; then
            MISSING_VARS+=("$var")
        fi
    done

    if [ ${#MISSING_VARS[@]} -ne 0 ]; then
        echo -e "${RED}Missing Auth0 variables in .env.local:${NC}"
        for var in "${MISSING_VARS[@]}"; do
            echo -e "  - $var"
            VALUE=$(prompt_with_default "$var" "")
            echo "$var=$VALUE" >> .env.local
        done
    fi
else
    echo -e "${BLUE}Creating .env.local from example...${NC}"
    cp .env.example .env.local
fi

# Verify Auth0 Connection
echo -e "\n${GREEN}Verifying Auth0 Configuration...${NC}"
npx tsx scripts/verify-auth0.ts || {
    echo -e "${RED}Failed to verify Auth0 configuration. Please check your settings.${NC}"
    echo -e "${BLUE}You can update them later in .env.local${NC}"
}

# Verify other required environment variables
echo -e "\n${GREEN}Verifying other environment variables...${NC}"
OTHER_VARS=(
    "NODE_ENV"
    "NEXT_PUBLIC_APP_URL"
    "CORS_ORIGINS"
)

for var in "${OTHER_VARS[@]}"; do
    if ! grep -q "^$var=" .env.local; then
        echo -e "${BLUE}Setting up $var...${NC}"
        case $var in
            "NODE_ENV")
                echo "NODE_ENV=development" >> .env.local
                ;;
            "NEXT_PUBLIC_APP_URL")
                echo "NEXT_PUBLIC_APP_URL=http://localhost:3000" >> .env.local
                ;;
            "CORS_ORIGINS")
                echo "CORS_ORIGINS=http://localhost:3000" >> .env.local
                ;;
            *)
                VALUE=$(prompt_with_default "$var" "")
                echo "$var=$VALUE" >> .env.local
                ;;
        esac
    fi
done

# Verify environment file permissions
echo -e "\n${GREEN}Securing environment files...${NC}"
chmod 600 .env.local
chmod 600 .env.example

# Verify MongoDB Connection
echo -e "\n${GREEN}Verifying MongoDB Connection...${NC}"
npx tsx scripts/verify-mongodb.ts || {
    echo -e "${RED}Failed to connect to MongoDB. Please check your connection string.${NC}"
    echo -e "${BLUE}You can update it later in .env.local${NC}"
}

# Git History Handling
echo -e "\n${GREEN}Git Setup${NC}"
if [ -f ".git/config" ] && grep -q "rom-developers" ".git/config"; then
    # This is the original repository
    echo -e "${BLUE}Original repository detected. Cleaning up history...${NC}"
    
    # Create a temporary branch
    git checkout --orphan temp_branch
    
    # Add all files
    git add .
    
    # Create initial commit
    git commit -m "feat: Initial template setup"
    
    # Delete the main branch
    git branch -D main
    
    # Rename temp branch to main
    git branch -m main
    
    # Force push to remote
    echo -e "${BLUE}Pushing clean history to remote...${NC}"
    git push -f origin main
else
    # This is a template user
    echo -e "${BLUE}Setting up new repository...${NC}"
    rm -rf .git
    git init
    git add .
    git commit -m "feat: Initial project setup from AI Developer's Launch Pad"
fi

# Update Git configuration
git config user.name "$AUTHOR_NAME"
git config user.email "$AUTHOR_EMAIL"

# Update package.json
echo -e "\n${GREEN}Updating package.json...${NC}"
sed -i '' \
    -e "s/\"name\": \".*\"/\"name\": \"$PROJECT_NAME\"/" \
    -e "s/\"description\": \".*\"/\"description\": \"$PROJECT_DESCRIPTION\"/" \
    -e "s/\"author\": \".*\"/\"author\": \"$AUTHOR_NAME <$AUTHOR_EMAIL>\"/" \
    -e "s/\"version\": \".*\"/\"version\": \"1.0.0\"/" \
    package.json

# Clean up template files
echo -e "\n${GREEN}Removing template files...${NC}"
rm -rf \
    CONTRIBUTING.md \
    CODE_OF_CONDUCT.md \
    CHANGELOG.md \
    .github/workflows/* \
    .github/ISSUE_TEMPLATE/* \
    .github/PULL_REQUEST_TEMPLATE.md

# Create new README
echo -e "\n${GREEN}Creating new README.md...${NC}"
cat > README.md << EOL
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## Features
- 🚀 Next.js 14 with App Router
- 🔐 Auth0 Authentication
- 📊 MongoDB Database
- 🎨 Tailwind CSS
- 🧪 Testing Setup
- 📱 Responsive Design

## Getting Started

1. Clone the repository:
\`\`\`bash
git clone https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git
cd $PROJECT_NAME
\`\`\`

2. Install dependencies:
\`\`\`bash
npm install
\`\`\`

3. Set up environment variables:
\`\`\`bash
cp .env.example .env.local
# Update .env.local with your values
\`\`\`

4. Run the development server:
\`\`\`bash
npm run dev
\`\`\`

## Environment Variables

Required environment variables:
- \`AUTH0_SECRET\`
- \`AUTH0_BASE_URL\`
- \`AUTH0_ISSUER_BASE_URL\`
- \`AUTH0_CLIENT_ID\`
- \`AUTH0_CLIENT_SECRET\`
- \`MONGODB_URI\`

## License

MIT © $AUTHOR_NAME
EOL

# Create new LICENSE
echo -e "\n${GREEN}Creating new LICENSE...${NC}"
YEAR=$(date +%Y)
cat > LICENSE << EOL
MIT License

Copyright (c) $YEAR $AUTHOR_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL

# Verify project structure
echo -e "\n${GREEN}Verifying project structure...${NC}"
required_files=(
    "src/app/layout.tsx"
    "src/app/page.tsx"
    "src/lib/mongodb.ts"
    "src/components/ProtectedRoute.tsx"
    "tailwind.config.ts"
    "next.config.js"
    "package.json"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: Required file $file is missing${NC}"
        exit 1
    fi
done

# Verify dependencies
echo -e "\n${GREEN}Verifying dependencies...${NC}"
required_deps=(
    "@auth0/nextjs-auth0"
    "mongodb"
    "mongoose"
    "next"
    "react"
    "react-dom"
    "tailwindcss"
)

for dep in "${required_deps[@]}"; do
    if ! grep -q "\"$dep\":" package.json; then
        echo -e "${RED}Error: Required dependency $dep is missing${NC}"
        exit 1
    fi
done

# Show final configuration (safely)
echo -e "\n${GREEN}Environment Configuration Summary:${NC}"
echo -e "The following variables have been configured in .env.local:"

# Function to safely display environment variables
safe_display() {
    local var=$1
    local value=$(grep "^$var=" .env.local | cut -d '=' -f2)
    if [[ $var == *"SECRET"* || $var == *"KEY"* ]]; then
        echo -e "  $var = ${RED}[HIDDEN]${NC}"
    else
        echo -e "  $var = $value"
    fi
}

# Display all variables grouped by category
echo -e "\n${BLUE}Application:${NC}"
safe_display "NODE_ENV"
safe_display "NEXT_PUBLIC_APP_URL"

echo -e "\n${BLUE}MongoDB:${NC}"
safe_display "MONGODB_URI"

echo -e "\n${BLUE}Auth0:${NC}"
for var in "${AUTH0_VARS[@]}"; do
    safe_display "$var"
done

echo -e "\n${BLUE}Security:${NC}"
safe_display "CORS_ORIGINS"
safe_display "ENABLE_API_RATE_LIMITING"
safe_display "RATE_LIMIT_REQUESTS"

echo -e "\n${GREEN}✓ Environment configuration complete!${NC}"
echo -e "${BLUE}→ Your .env.local file has been created and configured${NC}"
echo -e "${BLUE}→ Make sure to keep this file secure and never commit it to version control${NC}"

echo -e "\n${BLUE}🎉 Initialization complete! Next steps:${NC}"
echo -e "1. Create a new repository on GitHub: ${GREEN}https://github.com/new${NC}"
echo -e "2. Push your code:"
echo -e "   ${GREEN}git remote add origin https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git${NC}"
echo -e "   ${GREEN}git push -u origin main${NC}"
echo -e "3. Set up your environment variables in ${GREEN}.env.local${NC}"
echo -e "4. Start developing with ${GREEN}npm run dev${NC}"

echo -e "\n${BLUE}Happy coding! 🚀${NC}" 