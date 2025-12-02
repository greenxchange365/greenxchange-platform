-- GreenXchange Platform - Complete Database Schema
-- PostgreSQL Database for Carbon Credit Trading Platform
-- Government-compliant with full audit trail

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(15) UNIQUE,
  aadhaar_hash VARCHAR(255), -- Encrypted Aadhaar for privacy
  user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('seller', 'buyer', 'admin', 'advisor')),
  full_name VARCHAR(255) NOT NULL,
  preferred_language VARCHAR(10) DEFAULT 'en', -- 'en', 'hi', 'mr', 'gu', 'ta', 'te', 'bn'
  kyc_status VARCHAR(20) DEFAULT 'pending' CHECK (kyc_status IN ('pending', 'verified', 'rejected')),
  kyc_verified_at TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_users_kyc_status ON users(kyc_status);

-- ============================================
-- 2. SELLER PROFILES TABLE
-- ============================================
CREATE TABLE seller_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  business_name VARCHAR(255),
  business_type VARCHAR(50) CHECK (business_type IN ('individual', 'farmer', 'cooperative', 'company', 'ngo')),
  pan_number VARCHAR(10),
  gstin VARCHAR(15),
  bank_account_number VARCHAR(20),
  bank_ifsc VARCHAR(11),
  bank_name VARCHAR(100),
  account_holder_name VARCHAR(255),
  address_line1 VARCHAR(255),
  address_line2 VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  pincode VARCHAR(6),
  land_ownership_proof_url TEXT,
  advisor_id UUID REFERENCES users(id), -- Assigned carbon credit advisor
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX idx_seller_profiles_user_id ON seller_profiles(user_id);
CREATE INDEX idx_seller_profiles_advisor_id ON seller_profiles(advisor_id);

-- ============================================
-- 3. BUYER PROFILES TABLE
-- ============================================
CREATE TABLE buyer_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  company_name VARCHAR(255),
  company_type VARCHAR(50) CHECK (company_type IN ('corporate', 'individual', 'ngo', 'government', 'startup')),
  gstin VARCHAR(15),
  pan_number VARCHAR(10),
  industry_sector VARCHAR(100),
  esg_goals TEXT,
  annual_credit_requirement INTEGER,
  address_line1 VARCHAR(255),
  address_line2 VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  pincode VARCHAR(6),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX idx_buyer_profiles_user_id ON buyer_profiles(user_id);

-- ============================================
-- 4. CARBON PROJECTS TABLE
-- ============================================
CREATE TABLE carbon_projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  seller_id UUID REFERENCES users(id) ON DELETE CASCADE,
  project_name VARCHAR(255) NOT NULL,
  project_type VARCHAR(50) NOT NULL CHECK (project_type IN ('forestry', 'agroforestry', 'solar', 'wind', 'biogas', 'waste_management', 'energy_efficiency', 'other')),
  project_description TEXT,
  location_latitude DECIMAL(10, 8),
  location_longitude DECIMAL(11, 8),
  location_address TEXT,
  land_area_acres DECIMAL(10, 2),
  estimated_credits_per_year INTEGER,
  project_start_date DATE,
  project_duration_years INTEGER,
  status VARCHAR(30) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'under_review', 'approved', 'rejected', 'active', 'completed', 'suspended')),
  government_registration_number VARCHAR(100),
  bee_certificate_number VARCHAR(100),
  moefcc_approval_number VARCHAR(100),
  third_party_verifier VARCHAR(255),
  verification_report_url TEXT,
  rejection_reason TEXT,
  approved_at TIMESTAMP,
  approved_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_carbon_projects_seller_id ON carbon_projects(seller_id);
CREATE INDEX idx_carbon_projects_status ON carbon_projects(status);
CREATE INDEX idx_carbon_projects_type ON carbon_projects(project_type);

-- ============================================
-- 5. REGISTRATION APPLICATIONS TABLE
-- ============================================
CREATE TABLE registration_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES carbon_projects(id) ON DELETE CASCADE,
  seller_id UUID REFERENCES users(id),
  application_type VARCHAR(50) CHECK (application_type IN ('new', 'renewal', 'modification')),
  application_status VARCHAR(30) DEFAULT 'pending' CHECK (application_status IN ('pending', 'documents_required', 'documents_submitted', 'under_internal_review', 'submitted_to_govt', 'govt_under_review', 'approved', 'rejected')),
  submitted_to_government_at TIMESTAMP,
  government_response_date DATE,
  government_tracking_number VARCHAR(100),
  government_agency VARCHAR(50), -- 'BEE', 'MoEFCC', 'SPCB'
  service_fee_amount DECIMAL(10, 2),
  service_fee_paid BOOLEAN DEFAULT false,
  service_fee_paid_at TIMESTAMP,
  service_fee_transaction_id VARCHAR(100),
  assigned_advisor_id UUID REFERENCES users(id),
  internal_notes TEXT,
  rejection_reason TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_registration_applications_project_id ON registration_applications(project_id);
CREATE INDEX idx_registration_applications_seller_id ON registration_applications(seller_id);
CREATE INDEX idx_registration_applications_status ON registration_applications(application_status);
CREATE INDEX idx_registration_applications_advisor_id ON registration_applications(assigned_advisor_id);

-- ============================================
-- 6. DOCUMENTS TABLE
-- ============================================
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entity_type VARCHAR(50) CHECK (entity_type IN ('project', 'user', 'application', 'transaction')),
  entity_id UUID NOT NULL,
  document_type VARCHAR(50) NOT NULL, -- 'land_ownership', 'aadhaar', 'pan', 'gstin', 'project_proposal', 'verification_report', 'certificate', 'bank_statement'
  document_name VARCHAR(255),
  file_url TEXT NOT NULL,
  file_size_kb INTEGER,
  mime_type VARCHAR(100),
  verification_status VARCHAR(20) DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
  verified_by UUID REFERENCES users(id),
  verified_at TIMESTAMP,
  verification_notes TEXT,
  digilocker_verified BOOLEAN DEFAULT false,
  digilocker_doc_id VARCHAR(100),
  uploaded_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_documents_entity ON documents(entity_type, entity_id);
CREATE INDEX idx_documents_type ON documents(document_type);
CREATE INDEX idx_documents_status ON documents(verification_status);

-- ============================================
-- 7. CARBON CREDITS INVENTORY TABLE
-- ============================================
CREATE TABLE carbon_credits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES carbon_projects(id),
  seller_id UUID REFERENCES users(id),
  certificate_number VARCHAR(100) UNIQUE NOT NULL,
  credit_quantity INTEGER NOT NULL, -- Number of credits (1 credit = 1 ton CO2)
  vintage_year INTEGER NOT NULL, -- Year credits were generated
  verification_standard VARCHAR(50), -- 'VCS', 'Gold_Standard', 'CDM', 'India_BEE', 'ISO_14064'
  issuance_date DATE,
  expiry_date DATE,
  status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'listed', 'reserved', 'sold', 'retired', 'expired', 'cancelled')),
  listed_at TIMESTAMP,
  sold_at TIMESTAMP,
  retired_at TIMESTAMP,
  blockchain_hash VARCHAR(255), -- For future blockchain integration
  blockchain_network VARCHAR(50), -- 'polygon', 'ethereum'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_carbon_credits_project_id ON carbon_credits(project_id);
CREATE INDEX idx_carbon_credits_seller_id ON carbon_credits(seller_id);
CREATE INDEX idx_carbon_credits_status ON carbon_credits(status);
CREATE INDEX idx_carbon_credits_certificate ON carbon_credits(certificate_number);

-- ============================================
-- 8. MARKETPLACE LISTINGS TABLE
-- ============================================
CREATE TABLE marketplace_listings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  credit_id UUID REFERENCES carbon_credits(id),
  seller_id UUID REFERENCES users(id),
  quantity_available INTEGER NOT NULL,
  quantity_sold INTEGER DEFAULT 0,
  price_per_credit DECIMAL(10, 2) NOT NULL, -- In INR
  listing_status VARCHAR(20) DEFAULT 'active' CHECK (listing_status IN ('active', 'partially_sold', 'sold', 'cancelled', 'expired')),
  listing_type VARCHAR(20) DEFAULT 'fixed' CHECK (listing_type IN ('fixed', 'negotiable', 'auction')),
  minimum_purchase_quantity INTEGER DEFAULT 1,
  project_highlights TEXT,
  environmental_impact_description TEXT,
  co2_reduction_tons INTEGER,
  sdg_goals TEXT[], -- Sustainable Development Goals
  listed_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP,
  views_count INTEGER DEFAULT 0,
  inquiries_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_marketplace_listings_credit_id ON marketplace_listings(credit_id);
CREATE INDEX idx_marketplace_listings_seller_id ON marketplace_listings(seller_id);
CREATE INDEX idx_marketplace_listings_status ON marketplace_listings(listing_status);
CREATE INDEX idx_marketplace_listings_price ON marketplace_listings(price_per_credit);

-- ============================================
-- 9. TRANSACTIONS TABLE
-- ============================================
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaction_number VARCHAR(50) UNIQUE NOT NULL,
  listing_id UUID REFERENCES marketplace_listings(id),
  credit_id UUID REFERENCES carbon_credits(id),
  seller_id UUID REFERENCES users(id),
  buyer_id UUID REFERENCES users(id),
  quantity INTEGER NOT NULL,
  price_per_credit DECIMAL(10, 2) NOT NULL,
  total_amount DECIMAL(12, 2) NOT NULL,
  platform_commission_percent DECIMAL(5, 2) DEFAULT 3.00,
  platform_commission_amount DECIMAL(10, 2),
  seller_payout_amount DECIMAL(12, 2),
  gst_amount DECIMAL(10, 2),
  gst_rate DECIMAL(5, 2) DEFAULT 18.00,
  tds_amount DECIMAL(10, 2),
  tds_rate DECIMAL(5, 2),
  payment_status VARCHAR(30) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'held_in_escrow', 'released_to_seller', 'refunded', 'failed', 'cancelled')),
  payment_gateway VARCHAR(20), -- 'razorpay', 'paytm', 'bank_transfer'
  payment_gateway_transaction_id VARCHAR(100),
  payment_gateway_order_id VARCHAR(100),
  paid_at TIMESTAMP,
  seller_payout_status VARCHAR(30) DEFAULT 'pending' CHECK (seller_payout_status IN ('pending', 'processing', 'processed', 'failed')),
  seller_payout_at TIMESTAMP,
  seller_payout_reference VARCHAR(100),
  esign_document_url TEXT,
  esign_status VARCHAR(20) CHECK (esign_status IN ('pending', 'sent', 'signed_by_buyer', 'signed_by_seller', 'completed', 'failed')),
  esign_completed_at TIMESTAMP,
  transaction_certificate_url TEXT,
  invoice_number VARCHAR(50),
  invoice_url TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_transactions_seller_id ON transactions(seller_id);
CREATE INDEX idx_transactions_buyer_id ON transactions(buyer_id);
CREATE INDEX idx_transactions_status ON transactions(payment_status);
CREATE INDEX idx_transactions_number ON transactions(transaction_number);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);

-- ============================================
-- 10. COMPLIANCE LOGS TABLE
-- ============================================
CREATE TABLE compliance_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entity_type VARCHAR(50) CHECK (entity_type IN ('project', 'transaction', 'user', 'application')),
  entity_id UUID NOT NULL,
  compliance_type VARCHAR(50), -- 'kyc', 'project_approval', 'transaction_report', 'tax_filing', 'annual_audit'
  status VARCHAR(30) CHECK (status IN ('compliant', 'pending', 'non_compliant', 'under_review')),
  government_agency VARCHAR(100), -- 'BEE', 'MoEFCC', 'SPCB', 'GST', 'Income_Tax'
  submission_date DATE,
  response_date DATE,
  reference_number VARCHAR(100),
  compliance_certificate_url TEXT,
  notes TEXT,
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_compliance_logs_entity ON compliance_logs(entity_type, entity_id);
CREATE INDEX idx_compliance_logs_type ON compliance_logs(compliance_type);
CREATE INDEX idx_compliance_logs_status ON compliance_logs(status);

-- ============================================
-- 11. SUPPORT TICKETS TABLE
-- ============================================
CREATE TABLE support_tickets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_number VARCHAR(50) UNIQUE NOT NULL,
  user_id UUID REFERENCES users(id),
  subject VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(50) CHECK (category IN ('registration', 'payment', 'technical', 'compliance', 'listing', 'general', 'complaint')),
  priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  status VARCHAR(30) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'waiting_on_customer', 'resolved', 'closed')),
  assigned_to UUID REFERENCES users(id),
  first_response_at TIMESTAMP,
  resolved_at TIMESTAMP,
  closed_at TIMESTAMP,
  satisfaction_rating INTEGER CHECK (satisfaction_rating BETWEEN 1 AND 5),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_support_tickets_user_id ON support_tickets(user_id);
CREATE INDEX idx_support_tickets_status ON support_tickets(status);
CREATE INDEX idx_support_tickets_assigned_to ON support_tickets(assigned_to);
CREATE INDEX idx_support_tickets_number ON support_tickets(ticket_number);

-- ============================================
-- 12. SUPPORT TICKET MESSAGES TABLE
-- ============================================
CREATE TABLE support_ticket_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_id UUID REFERENCES support_tickets(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES users(id),
  message TEXT NOT NULL,
  is_internal_note BOOLEAN DEFAULT false,
  attachment_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_support_ticket_messages_ticket_id ON support_ticket_messages(ticket_id);

-- ============================================
-- 13. NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  notification_type VARCHAR(50), -- 'application_update', 'payment', 'listing', 'message', 'system'
  title VARCHAR(255),
  message TEXT,
  channel VARCHAR(20) CHECK (channel IN ('email', 'sms', 'whatsapp', 'in_app', 'push')),
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP,
  sent_at TIMESTAMP,
  delivery_status VARCHAR(20) CHECK (delivery_status IN ('pending', 'sent', 'delivered', 'failed')),
  metadata JSONB, -- Additional data for the notification
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_type ON notifications(notification_type);

-- ============================================
-- 14. AUDIT LOGS TABLE
-- ============================================
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  action VARCHAR(100) NOT NULL, -- 'create', 'update', 'delete', 'login', 'logout', 'payment', 'approval'
  entity_type VARCHAR(50),
  entity_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address VARCHAR(45),
  user_agent TEXT,
  session_id VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- ============================================
-- 15. EDUCATIONAL CONTENT TABLE
-- ============================================
CREATE TABLE educational_content (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  content_type VARCHAR(30) CHECK (content_type IN ('article', 'video', 'faq', 'guide', 'tutorial', 'case_study')),
  language VARCHAR(10) DEFAULT 'en',
  content TEXT,
  video_url TEXT,
  thumbnail_url TEXT,
  category VARCHAR(50), -- 'getting_started', 'eligibility', 'process', 'success_stories', 'compliance', 'marketplace'
  tags TEXT[],
  view_count INTEGER DEFAULT 0,
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMP,
  author_id UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_educational_content_language ON educational_content(language);
CREATE INDEX idx_educational_content_category ON educational_content(category);
CREATE INDEX idx_educational_content_published ON educational_content(is_published);

-- ============================================
-- 16. SYSTEM SETTINGS TABLE
-- ============================================
CREATE TABLE system_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  setting_key VARCHAR(100) UNIQUE NOT NULL,
  setting_value TEXT,
  setting_type VARCHAR(20) CHECK (setting_type IN ('string', 'number', 'boolean', 'json')),
  description TEXT,
  is_public BOOLEAN DEFAULT false,
  updated_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert default settings
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
('platform_commission_rate', '3.0', 'number', 'Default platform commission percentage', false),
('gst_rate', '18.0', 'number', 'GST rate percentage', false),
('min_credit_price', '100', 'number', 'Minimum price per credit in INR', true),
('max_credit_price', '10000', 'number', 'Maximum price per credit in INR', true),
('registration_service_fee', '15000', 'number', 'Service fee for registration assistance in INR', true),
('platform_name', 'GreenXchange', 'string', 'Platform name', true),
('support_email', 'support@greenxchange.in', 'string', 'Support email address', true),
('support_phone', '+91-XXXXXXXXXX', 'string', 'Support phone number', true);

-- ============================================
-- FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_seller_profiles_updated_at BEFORE UPDATE ON seller_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_buyer_profiles_updated_at BEFORE UPDATE ON buyer_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_carbon_projects_updated_at BEFORE UPDATE ON carbon_projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_registration_applications_updated_at BEFORE UPDATE ON registration_applications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_carbon_credits_updated_at BEFORE UPDATE ON carbon_credits FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_marketplace_listings_updated_at BEFORE UPDATE ON marketplace_listings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_support_tickets_updated_at BEFORE UPDATE ON support_tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_educational_content_updated_at BEFORE UPDATE ON educational_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate transaction number
CREATE OR REPLACE FUNCTION generate_transaction_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.transaction_number = 'TXN' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(nextval('transaction_number_seq')::TEXT, 6, '0');
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE SEQUENCE transaction_number_seq;
CREATE TRIGGER generate_transaction_number_trigger BEFORE INSERT ON transactions FOR EACH ROW EXECUTE FUNCTION generate_transaction_number();

-- Function to generate ticket number
CREATE OR REPLACE FUNCTION generate_ticket_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.ticket_number = 'TKT' || TO_CHAR(NOW(), 'YYYYMMDD') || LPAD(nextval('ticket_number_seq')::TEXT, 6, '0');
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE SEQUENCE ticket_number_seq;
CREATE TRIGGER generate_ticket_number_trigger BEFORE INSERT ON support_tickets FOR EACH ROW EXECUTE FUNCTION generate_ticket_number();

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE seller_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE buyer_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE carbon_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE registration_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE carbon_credits ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketplace_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE educational_content ENABLE ROW LEVEL SECURITY;

-- Users can view their own profile
CREATE POLICY users_select_own ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY users_update_own ON users FOR UPDATE USING (auth.uid() = id);

-- Sellers can view and update their own profile
CREATE POLICY seller_profiles_select_own ON seller_profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY seller_profiles_update_own ON seller_profiles FOR UPDATE USING (auth.uid() = user_id);

-- Buyers can view and update their own profile
CREATE POLICY buyer_profiles_select_own ON buyer_profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY buyer_profiles_update_own ON buyer_profiles FOR UPDATE USING (auth.uid() = user_id);

-- Sellers can manage their own projects
CREATE POLICY carbon_projects_select_own ON carbon_projects FOR SELECT USING (auth.uid() = seller_id);
CREATE POLICY carbon_projects_insert_own ON carbon_projects FOR INSERT WITH CHECK (auth.uid() = seller_id);
CREATE POLICY carbon_projects_update_own ON carbon_projects FOR UPDATE USING (auth.uid() = seller_id);

-- Public can view active marketplace listings
CREATE POLICY marketplace_listings_select_public ON marketplace_listings FOR SELECT USING (listing_status = 'active');

-- Users can view their own transactions
CREATE POLICY transactions_select_own ON transactions FOR SELECT USING (auth.uid() = seller_id OR auth.uid() = buyer_id);

-- Users can view their own notifications
CREATE POLICY notifications_select_own ON notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY notifications_update_own ON notifications FOR UPDATE USING (auth.uid() = user_id);

-- Public can view published educational content
CREATE POLICY educational_content_select_public ON educational_content FOR SELECT USING (is_published = true);

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- View for active marketplace with project details
CREATE VIEW active_marketplace_view AS
SELECT 
    ml.id,
    ml.quantity_available,
    ml.price_per_credit,
    ml.listing_status,
    ml.views_count,
    ml.listed_at,
    cc.certificate_number,
    cc.credit_quantity,
    cc.vintage_year,
    cc.verification_standard,
    cp.project_name,
    cp.project_type,
    cp.project_description,
    cp.location_address,
    cp.co2_reduction_tons,
    u.full_name as seller_name,
    sp.business_name as seller_business
FROM marketplace_listings ml
JOIN carbon_credits cc ON ml.credit_id = cc.id
JOIN carbon_projects cp ON cc.project_id = cp.id
JOIN users u ON ml.seller_id = u.id
LEFT JOIN seller_profiles sp ON u.id = sp.user_id
WHERE ml.listing_status = 'active';

-- View for transaction summary
CREATE VIEW transaction_summary_view AS
SELECT 
    t.id,
    t.transaction_number,
    t.quantity,
    t.total_amount,
    t.payment_status,
    t.created_at,
    seller.full_name as seller_name,
    buyer.full_name as buyer_name,
    cp.project_name,
    cc.certificate_number
FROM transactions t
JOIN users seller ON t.seller_id = seller.id
JOIN users buyer ON t.buyer_id = buyer.id
JOIN carbon_credits cc ON t.credit_id = cc.id
JOIN carbon_projects cp ON cc.project_id = cp.id;

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON TABLE users IS 'Core user accounts for sellers, buyers, admins, and advisors';
COMMENT ON TABLE seller_profiles IS 'Extended profile information for carbon credit sellers';
COMMENT ON TABLE buyer_profiles IS 'Extended profile information for carbon credit buyers';
COMMENT ON TABLE carbon_projects IS 'Carbon credit generation projects with government approvals';
COMMENT ON TABLE registration_applications IS 'Government registration applications tracking';
COMMENT ON TABLE documents IS 'Document storage and verification for all entities';
COMMENT ON TABLE carbon_credits IS 'Inventory of carbon credits with certificates';
COMMENT ON TABLE marketplace_listings IS 'Active listings of carbon credits for sale';
COMMENT ON TABLE transactions IS 'Complete transaction records with compliance data';
COMMENT ON TABLE compliance_logs IS 'Government compliance and audit trail';
COMMENT ON TABLE support_tickets IS 'Customer support ticket management';
COMMENT ON TABLE notifications IS 'Multi-channel notification system';
COMMENT ON TABLE audit_logs IS 'Complete audit trail for all system actions';
COMMENT ON TABLE educational_content IS 'Multi-language educational resources';
COMMENT ON TABLE system_settings IS 'Platform-wide configuration settings';
