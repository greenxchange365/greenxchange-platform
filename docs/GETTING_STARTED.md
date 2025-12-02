# Getting Started with GreenXchange Platform

This guide will help you set up the GreenXchange platform for development.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** 18.0 or higher ([Download](https://nodejs.org/))
- **npm** 9.0 or higher (comes with Node.js)
- **Git** ([Download](https://git-scm.com/))
- **Code Editor** (VS Code recommended)

## Step 1: Clone the Repository

```bash
git clone https://github.com/greenxchange365/greenxchange-platform.git
cd greenxchange-platform
```

## Step 2: Install Dependencies

```bash
npm install
```

This will install all required packages including Next.js, React, Supabase client, and other dependencies.

## Step 3: Set Up Supabase

### 3.1 Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Sign in or create an account
3. Click "New Project"
4. Fill in the details:
   - **Name:** greenxchange
   - **Database Password:** (create a strong password)
   - **Region:** Asia South (Mumbai) - ap-south-1
   - **Pricing Plan:** Free (for development)
5. Click "Create new project"
6. Wait for the project to be provisioned (2-3 minutes)

### 3.2 Get Supabase Credentials

1. In your Supabase project dashboard, click on "Settings" (gear icon)
2. Go to "API" section
3. Copy the following:
   - **Project URL** (looks like: https://xxxxx.supabase.co)
   - **anon public key** (starts with: eyJhbGc...)
   - **service_role key** (starts with: eyJhbGc... - keep this secret!)

### 3.3 Run Database Schema

1. In Supabase dashboard, go to "SQL Editor"
2. Click "New Query"
3. Copy the entire content from `database/schema.sql` file
4. Paste it into the SQL editor
5. Click "Run" or press Ctrl+Enter
6. You should see "Success. No rows returned" message
7. Go to "Table Editor" to verify all 16 tables are created

## Step 4: Set Up Environment Variables

1. Copy the example environment file:
```bash
cp .env.example .env.local
```

2. Open `.env.local` in your code editor

3. Fill in the Supabase credentials:
```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

4. For now, you can leave other variables as they are. We'll configure them later when needed.

## Step 5: Run the Development Server

```bash
npm run dev
```

The application will start at [http://localhost:3000](http://localhost:3000)

You should see the GreenXchange homepage!

## Step 6: Verify Setup

### Check Database Connection

1. Open [http://localhost:3000/api/health](http://localhost:3000/api/health)
2. You should see a JSON response indicating the system is healthy

### Check Supabase Connection

1. Try to sign up for a new account
2. Check Supabase dashboard → Authentication → Users
3. You should see the new user created

## Project Structure

```
greenxchange-platform/
├── app/                    # Next.js app directory (pages and layouts)
│   ├── (auth)/            # Authentication pages (login, signup)
│   ├── (dashboard)/       # Dashboard layouts
│   ├── seller/            # Seller portal pages
│   ├── buyer/             # Buyer portal pages
│   ├── admin/             # Admin panel pages
│   ├── marketplace/       # Marketplace pages
│   └── api/               # API routes
├── components/            # Reusable React components
│   ├── ui/               # UI components (buttons, inputs, etc.)
│   ├── forms/            # Form components
│   ├── layouts/          # Layout components
│   └── shared/           # Shared components
├── lib/                   # Utility functions and configurations
│   ├── supabase/         # Supabase client and helpers
│   ├── utils/            # Helper functions
│   └── validations/      # Zod schemas for validation
├── database/              # Database files
│   ├── schema.sql        # Complete database schema
│   ├── migrations/       # Migration files
│   └── seed.sql          # Seed data for development
├── public/               # Static assets (images, fonts, etc.)
├── docs/                 # Documentation
└── tests/                # Test files
```

## Common Development Tasks

### Creating a New Page

1. Create a new file in the `app` directory:
```bash
# Example: Create a new page at /about
touch app/about/page.tsx
```

2. Add basic page content:
```tsx
export default function AboutPage() {
  return (
    <div>
      <h1>About GreenXchange</h1>
      <p>Your content here</p>
    </div>
  );
}
```

### Creating a New API Route

1. Create a new file in `app/api`:
```bash
mkdir -p app/api/example
touch app/api/example/route.ts
```

2. Add API logic:
```typescript
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({ message: 'Hello from API' });
}
```

### Adding a New Database Table

1. Create a migration file:
```bash
touch database/migrations/001_add_new_table.sql
```

2. Write your SQL:
```sql
CREATE TABLE new_table (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

3. Run the migration in Supabase SQL Editor

### Working with Supabase

```typescript
// Example: Fetch data from database
import { createClient } from '@/lib/supabase/client';

const supabase = createClient();

// Select data
const { data, error } = await supabase
  .from('users')
  .select('*')
  .eq('user_type', 'seller');

// Insert data
const { data, error } = await supabase
  .from('carbon_projects')
  .insert({
    project_name: 'Solar Farm',
    seller_id: userId,
    project_type: 'solar'
  });

// Update data
const { data, error } = await supabase
  .from('carbon_projects')
  .update({ status: 'approved' })
  .eq('id', projectId);
```

## Development Workflow

### 1. Create a New Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes

- Write code
- Test locally
- Commit frequently

### 3. Commit Changes

```bash
git add .
git commit -m "Add: description of your changes"
```

### 4. Push to GitHub

```bash
git push origin feature/your-feature-name
```

### 5. Create Pull Request

1. Go to GitHub repository
2. Click "Pull Requests"
3. Click "New Pull Request"
4. Select your branch
5. Add description
6. Submit for review

## Testing

### Run Type Checking

```bash
npm run type-check
```

### Run Linting

```bash
npm run lint
```

### Format Code

```bash
npm run format
```

### Run Tests (when available)

```bash
npm test
```

## Troubleshooting

### Port 3000 Already in Use

```bash
# Kill the process using port 3000
# On Mac/Linux:
lsof -ti:3000 | xargs kill -9

# On Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Or use a different port:
PORT=3001 npm run dev
```

### Supabase Connection Error

1. Check your `.env.local` file has correct credentials
2. Verify your Supabase project is running
3. Check if your IP is allowed (Supabase → Settings → Database → Connection Pooling)

### Module Not Found Error

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Database Schema Issues

1. Go to Supabase SQL Editor
2. Run the schema.sql file again
3. Check for any error messages
4. Verify tables are created in Table Editor

## Next Steps

Now that you have the development environment set up:

1. **Explore the codebase** - Familiarize yourself with the project structure
2. **Read the documentation** - Check out `docs/TECHNICAL_ARCHITECTURE.md`
3. **Set up Razorpay** - For payment integration (see Razorpay setup guide)
4. **Configure government APIs** - DigiLocker, Aadhaar, e-Sign (when ready)
5. **Start building features** - Pick a task and start coding!

## Learning Resources

### Next.js
- [Next.js Documentation](https://nextjs.org/docs)
- [Learn Next.js](https://nextjs.org/learn)

### React
- [React Documentation](https://react.dev)
- [React Tutorial](https://react.dev/learn)

### Supabase
- [Supabase Documentation](https://supabase.com/docs)
- [Supabase with Next.js](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs)

### TypeScript
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript for React](https://react-typescript-cheatsheet.netlify.app/)

### Tailwind CSS
- [Tailwind Documentation](https://tailwindcss.com/docs)
- [Tailwind UI Components](https://tailwindui.com/)

## Getting Help

- **Documentation:** Check the `docs/` folder
- **Issues:** Create an issue on GitHub
- **Discussions:** Use GitHub Discussions
- **Email:** dev@greenxchange.in

## Contributing

We welcome contributions! Please read `docs/CONTRIBUTING.md` for guidelines.

---

**Happy Coding! 🚀**

Build something amazing for a sustainable future! 🌱
