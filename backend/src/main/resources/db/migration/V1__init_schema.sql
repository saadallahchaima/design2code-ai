-- RenoDesign Database Initial Schema
-- V1__init_schema.sql

-- 1. Users table
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    profile_image TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- 2. Projects table
CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    room_type VARCHAR(100),
    style VARCHAR(100),
    cover_image TEXT,
    before_image TEXT,
    after_image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 3. Services table
CREATE TABLE IF NOT EXISTS services (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image TEXT,
    active BOOLEAN DEFAULT TRUE NOT NULL
);

-- 4. Materials table
CREATE TABLE IF NOT EXISTS materials (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL, -- 'wall', 'floor', etc.
    description TEXT,
    image TEXT,
    color VARCHAR(100),
    price_range VARCHAR(50),
    active BOOLEAN DEFAULT TRUE NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_materials_category ON materials(category);

-- 5. Styles table
CREATE TABLE IF NOT EXISTS styles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image TEXT,
    prompt_instructions TEXT,
    active BOOLEAN DEFAULT TRUE NOT NULL
);

-- 6. Transformations table
CREATE TABLE IF NOT EXISTS transformations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    original_image_url TEXT NOT NULL,
    generated_image_url TEXT,
    room_type VARCHAR(100) NOT NULL,
    style VARCHAR(100) NOT NULL,
    wall_material VARCHAR(100),
    floor_material VARCHAR(100),
    lighting VARCHAR(100),
    custom_prompt TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING', -- PENDING, PROCESSING, COMPLETED, FAILED
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_transformations_user_id ON transformations(user_id);
CREATE INDEX IF NOT EXISTS idx_transformations_status ON transformations(status);

-- 7. Quote Requests table
CREATE TABLE IF NOT EXISTS quote_requests (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    transformation_id BIGINT REFERENCES transformations(id) ON DELETE SET NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    room_type VARCHAR(100) NOT NULL,
    surface_area DOUBLE PRECISION,
    message TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING', -- PENDING, CONTACTED, IN_PROGRESS, COMPLETED, CANCELLED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_quote_requests_user_id ON quote_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_quote_requests_status ON quote_requests(status);

-- 8. Favorites table
CREATE TABLE IF NOT EXISTS favorites (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    project_id BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT uk_user_project UNIQUE (user_id, project_id)
);

-- 9. Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
