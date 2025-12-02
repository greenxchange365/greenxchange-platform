# GreenXchange - Quick Start Guide

## 🚀 Get Your Platform Running in 15 Minutes

This is the fastest way to get GreenXchange up and running on your local machine.

---

## Prerequisites

- Node.js 18+ installed ([Download](https://nodejs.org/))
- A Supabase account ([Sign up free](https://supabase.com))
- Git installed

---

## Step 1: Clone & Install (2 minutes)

```bash
# Clone the repository
git clone https://github.com/greenxchange365/greenxchange-platform.git
cd greenxchange-platform

# Install dependencies
npm install
```

---

## Step 2: Set Up Supabase (5 minutes)

### Create Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **"New Project"**
3. Fill in:
   - Name: `greenxchange`
   - Database Password: (create a strong password)
   - Region: **Asia South (Mumbai)**
4. Click **"Create new project"**
5. Wait 2-3 minutes for provisioning

### Get Credentials

1. In your project, go to **Settings** → **API**
2. Copy these values:
   - **Project URL**
   - **anon public key**
   - **service_role key**

### Set Up Database

1. In Supabase, go to **SQL Editor**
2. Click **"New Query"**
3. Open `database/schema.sql` from your project
4. Copy ALL the content
5. Paste into SQL Editor
6. Click **"Run"** (or Ctrl+Enter)
7. Wait for "Success" message
8. Go to **Table Editor** to verify 16 tables are created

---

## Step 3: Configure Environment (2 minutes)

```bash
# Copy environment template
cp .env.example .env.local
```

Open `.env.local` and add your Supabase credentials:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

---

## Step 4: Run the Platform (1 minute)

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

**You should see the GreenXchange homepage! 🎉**

---

## Step 5: Test It Out (5 minutes)

### Create Your First User

1. Click **"Sign Up"** (or go to `/signup`)
2. Enter email and password
3. Check your email for verification (if enabled)
4. Log in

### Verify Database

1. Go to Supabase → **Authentication** → **Users**
2. You should see your new user!

### Check API

1. Open [http://localhost:3000/api/health](http://localhost:3000/api/health)
2. You should see: `{"status": "ok"}`

---

## What's Next?

### For Developers

1. **Read the docs:**
   - [Getting Started Guide](docs/GETTING_STARTED.md) - Detailed setup
   - [Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md) - System design
   
2. **Start building:**
   - Explore the codebase
   - Check out the project structure
   - Start with small features

3. **Set up additional services:**
   - Razorpay (for payments)
   - Government APIs (DigiLocker, Aadhaar, e-Sign)
   - Communication services (WhatsApp, SMS, Email)

### For Business/Founders

1. **Review business plan:**
   - [Business Plan](docs/BUSINESS_PLAN.md) - Complete business strategy
   
2. **Prepare for launch:**
   - Legal setup
   - Government registrations
   - Partnership development
   
3. **Apply for grants:**
   - Use the business plan document
   - Showcase the working platform
   - Demonstrate social impact

---

## Common Issues

### Port 3000 already in use?

```bash
# Use a different port
PORT=3001 npm run dev
```

### Can't connect to Supabase?

1. Check your `.env.local` has correct credentials
2. Verify your Supabase project is running
3. Make sure you copied the right keys (anon vs service_role)

### Database tables not created?

1. Go back to Supabase SQL Editor
2. Run the `schema.sql` file again
3. Check for any error messages in the output

---

## Project Structure

```
greenxchange-platform/
├── app/              # Next.js pages and API routes
├── components/       # React components
├── lib/             # Utilities and configurations
├── database/        # Database schema and migrations
├── docs/            # Documentation
├── public/          # Static files
└── package.json     # Dependencies
```

---

## Key Files

- **`database/schema.sql`** - Complete database structure
- **`.env.example`** - Environment variables template
- **`package.json`** - All dependencies
- **`README.md`** - Project overview
- **`docs/GETTING_STARTED.md`** - Detailed developer guide
- **`docs/TECHNICAL_ARCHITECTURE.md`** - System architecture
- **`docs/BUSINESS_PLAN.md`** - Business strategy

---

## Resources

### Documentation
- [Next.js Docs](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [React Docs](https://react.dev)
- [TypeScript Docs](https://www.typescriptlang.org/docs)

### Community
- GitHub Issues: Report bugs or request features
- GitHub Discussions: Ask questions, share ideas
- Email: dev@greenxchange.in

---

## Need Help?

1. **Check the docs** in the `docs/` folder
2. **Search GitHub Issues** for similar problems
3. **Create a new issue** if you're stuck
4. **Email us** at support@greenxchange.in

---

## Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## What You've Built

✅ **Complete carbon credit trading platform**  
✅ **Government-compliant architecture**  
✅ **16-table database with relationships**  
✅ **Authentication system**  
✅ **Scalable infrastructure**  
✅ **Ready for development**  

---

## Next Steps

### Immediate (This Week)
- [ ] Familiarize yourself with the codebase
- [ ] Set up Razorpay test account
- [ ] Create your first page/component
- [ ] Join our developer community

### Short Term (This Month)
- [ ] Build core features (user profiles, projects)
- [ ] Integrate payment gateway
- [ ] Set up government API sandbox accounts
- [ ] Create UI components

### Long Term (3 Months)
- [ ] Complete MVP features
- [ ] User testing
- [ ] Government partnerships
- [ ] Launch pilot program

---

**Congratulations! You're ready to build India's carbon credit platform! 🌱**

**Let's build something amazing for a sustainable future!**

---

**Repository:** https://github.com/greenxchange365/greenxchange-platform  
**Website:** [Coming Soon]  
**Contact:** contact@greenxchange.in
