# GreenXchange - Carbon Credit Trading Platform

## 🌱 Vision
GreenXchange is India's first government-compliant, end-to-end carbon credit trading platform that empowers rural communities, farmers, and small businesses to participate in the carbon economy.

## 🎯 Mission
To democratize carbon credit trading in India by providing:
- **Education & Eligibility Assessment** - Help users understand if they can generate carbon credits
- **Government Registration Assistance** - Handle complex BEE/MoEFCC registration process
- **Secure Marketplace** - Connect verified sellers with buyers
- **Complete Compliance** - Built-in government compliance and transparency

## 🏗️ Platform Overview

### Three-Sided Ecosystem

**1. Carbon Credit Generators (Sellers)**
- Farmers with agroforestry projects
- Renewable energy producers (solar, wind, biogas)
- Waste management facilities
- Forest conservation communities

**2. Buyers**
- Corporations meeting ESG goals
- Industries under PAT scheme
- International buyers
- CSR initiatives

**3. Government Integration**
- Real-time compliance monitoring
- Automated verification workflows
- Transparent transaction tracking

## 💡 Key Features

### For Sellers
- ✅ Multi-language support (Hindi, English, regional languages)
- ✅ Eligibility calculator & earnings estimator
- ✅ Guided registration process
- ✅ Document management with DigiLocker integration
- ✅ Government application tracking
- ✅ Automated credit listing post-approval
- ✅ Secure payment processing
- ✅ WhatsApp/SMS notifications

### For Buyers
- ✅ Browse verified carbon credits
- ✅ Detailed project information
- ✅ Secure purchase with e-Sign
- ✅ ESG reporting tools
- ✅ Certificate management

### For Admins
- ✅ Application review dashboard
- ✅ Document verification
- ✅ Government submission tracking
- ✅ Compliance monitoring
- ✅ Support ticket management

## 🛠️ Technology Stack

### Frontend
- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI Components:** Shadcn UI
- **Internationalization:** i18next
- **Hosting:** Vercel

### Backend
- **Database:** PostgreSQL (Supabase)
- **Authentication:** Supabase Auth
- **Storage:** Supabase Storage
- **API:** Next.js API Routes
- **Payment Gateway:** Razorpay

### Government Integrations
- **DigiLocker API** - Document verification
- **Aadhaar e-KYC** - Identity verification
- **NSDL e-Sign** - Digital signatures
- **GST API** - Business verification

### Communication
- **WhatsApp Business API** - Real-time updates
- **SMS Gateway** - Notifications
- **SendGrid** - Email service

### Future Enhancements
- **Blockchain:** Polygon (for immutable records)
- **AI/ML:** Eligibility assessment & fraud detection

## 📊 Database Schema

### Core Tables
1. **users** - User accounts (sellers, buyers, admins, advisors)
2. **seller_profiles** - Seller business information
3. **buyer_profiles** - Buyer company information
4. **carbon_projects** - Project details and government approvals
5. **registration_applications** - Government registration tracking
6. **documents** - Document storage and verification
7. **carbon_credits** - Credit inventory and certificates
8. **marketplace_listings** - Active credit listings
9. **transactions** - Trade records with compliance data
10. **compliance_logs** - Government compliance tracking
11. **support_tickets** - Customer support
12. **notifications** - Multi-channel notifications
13. **audit_logs** - Complete audit trail
14. **educational_content** - Multi-language learning resources

See `/database/schema.sql` for complete schema.

## 💰 Revenue Model

### Income Streams
1. **Registration Service Fee:** ₹10,000-₹25,000 per registration
2. **Trading Commission:** 3-5% per transaction
3. **Premium Services:** Annual compliance monitoring, analytics

### Projections
- **Year 1:** ₹30,00,000 - ₹55,00,000
- **Year 2:** ₹1,35,00,000+

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- npm or yarn
- Supabase account
- Razorpay account (for payments)

### Installation

```bash
# Clone the repository
git clone https://github.com/greenxchange365/greenxchange-platform.git
cd greenxchange-platform

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env.local
# Edit .env.local with your credentials

# Run database migrations
npm run db:migrate

# Start development server
npm run dev
```

Visit `http://localhost:3000`

## 📁 Project Structure

```
greenxchange-platform/
├── app/                    # Next.js app directory
│   ├── (auth)/            # Authentication pages
│   ├── (dashboard)/       # Dashboard layouts
│   ├── seller/            # Seller portal
│   ├── buyer/             # Buyer portal
│   ├── admin/             # Admin panel
│   └── api/               # API routes
├── components/            # Reusable components
│   ├── ui/               # UI components
│   ├── forms/            # Form components
│   └── layouts/          # Layout components
├── lib/                   # Utility functions
│   ├── supabase/         # Supabase client
│   ├── razorpay/         # Payment integration
│   └── utils/            # Helper functions
├── database/              # Database files
│   ├── schema.sql        # Complete schema
│   ├── migrations/       # Migration files
│   └── seed.sql          # Seed data
├── public/               # Static assets
├── docs/                 # Documentation
│   ├── API.md           # API documentation
│   ├── DEPLOYMENT.md    # Deployment guide
│   └── CONTRIBUTING.md  # Contribution guidelines
└── tests/                # Test files
```

## 🔐 Security & Compliance

- ✅ **Data Protection:** Compliant with Digital Personal Data Protection Act 2023
- ✅ **Encryption:** All sensitive data encrypted at rest and in transit
- ✅ **Audit Logs:** Complete audit trail for all transactions
- ✅ **KYC/AML:** Aadhaar-based verification
- ✅ **Government APIs:** Secure integration with DigiLocker, e-Sign
- ✅ **Payment Security:** PCI-DSS compliant via Razorpay

## 🌍 Government Alignment

### Regulatory Bodies
- Ministry of Environment, Forest and Climate Change (MoEFCC)
- Bureau of Energy Efficiency (BEE)
- State Pollution Control Boards (SPCBs)
- NITI Aayog

### Aligned Schemes
- PM-KUSUM (Solar for farmers)
- GOBAR-DHAN (Waste to wealth)
- Green India Mission
- National Action Plan on Climate Change

## 📈 Roadmap

### Phase 1: MVP (Months 1-4) ✅ Current
- Core platform development
- Basic features for sellers and buyers
- Government compliance integration
- Pilot in 1 district

### Phase 2: Government Grant (Month 5)
- Apply for government grants
- Showcase working platform
- User testimonials and impact metrics

### Phase 3: Scale (Months 6-12)
- Expand to 5 states
- Hire regional teams
- Marketing campaign
- Blockchain integration

### Phase 4: National Rollout (Year 2)
- Pan-India presence
- Mobile app launch
- AI-powered features
- International buyer integration

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 📞 Contact

- **Website:** [Coming Soon]
- **Email:** contact@greenxchange.in
- **GitHub:** https://github.com/greenxchange365
- **Support:** support@greenxchange.in

## 🙏 Acknowledgments

- Ministry of Environment, Forest and Climate Change
- Bureau of Energy Efficiency
- All farmers and rural communities working towards a sustainable future

---

**Built with 💚 for a sustainable India**

*Empowering rural India to participate in the carbon economy*
