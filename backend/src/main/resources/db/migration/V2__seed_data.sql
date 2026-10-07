-- RenoDesign Initial Seed Data
-- V2__seed_data.sql

-- Passwords:
-- admin@renodesign.com / Admin123! -> $2a$10$hK.fX9m1Hh2U5nC08b6Gme4aR9y1lGfE68hK1Q/H81Z054N8j3xce
-- client@renodesign.com / Client123! -> $2a$10$hK.fX9m1Hh2U5nC08b6Gme4aR9y1lGfE68hK1Q/H81Z054N8j3xce

INSERT INTO users (first_name, last_name, email, password_hash, phone, role, created_at, updated_at)
VALUES 
('Admin', 'RenoDesign', 'admin@renodesign.com', '$2a$10$wE8wUuXg9f7rC9bEq62xqeP0eZJ2O5Z4k8S5aP4F6rL7uX5hY7z6W', '+33123456789', 'ADMIN', NOW(), NOW()),
('Alexandre', 'Vidal', 'client@renodesign.com', '$2a$10$wE8wUuXg9f7rC9bEq62xqeP0eZJ2O5Z4k8S5aP4F6rL7uX5hY7z6W', '+33612345678', 'USER', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Styles
INSERT INTO styles (name, description, image, prompt_instructions, active)
VALUES
('Modern Luxury', 'Sleek lines, premium brass & bronze accents, rich marble surfaces and warm concealed architectural LED lighting.', 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80', 'high-end luxury modern interior, brushed brass fixtures, polished calacatta marble, recessed ambient lighting, bespoke architectural joinery', TRUE),
('Minimalist Warmth', 'Clean uncluttered aesthetics with organic textures, tactile linen, soft beige lime wash, and natural light.', 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80', 'warm minimalist interior, limestone and travertine accents, microcement, soft neutral tones, invisible storage, tranquil atmosphere', TRUE),
('Scandinavian Nordic', 'Light natural blonde oak, functional ergonomics, airy whites, cozy textured rugs and greenery.', 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80', 'authentic Scandinavian design, blonde Nordic oak flooring, serene muted palette, natural daylight, matte black lighting fixtures', TRUE),
('Industrial Chic', 'Exposed treated brick, steel glass partitions, raw concrete and aged cognac leather furniture.', 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80', 'loft industrial luxury, Crittall glass partitions, blackened steel, architectural concrete walls, warm vintage filaments', TRUE),
('Mediterranean Riviera', 'Terracotta tiles, smooth lime-washed arched walls, linen drapery, and warm sunlit breezy spaces.', 'https://images.unsplash.com/photo-1616486338812-3dADAe4b4ace?auto=format&fit=crop&w=1200&q=80', 'Mediterranean modern interior, handcrafted zellige tiles, arched openings, chalky plaster walls, warm linen upholstery', TRUE),
('Contemporary Elegance', 'Curated sculptural furniture, bold acoustic wood slats, tonal gray and greige harmony, recessed shadows.', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80', 'contemporary high architectural finish, acoustic slatted oak feature wall, floating furniture, museum-grade spotlighting', TRUE)
ON CONFLICT (name) DO NOTHING;

-- Materials (Wall)
INSERT INTO materials (name, category, description, image, color, price_range, active)
VALUES
('Lime Wash Velvet Plaster', 'wall', 'Breathable natural mineral lime paint creating subtle textured clouds and soft warmth.', 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=600&q=80', '#E4DCD3', '€€', TRUE),
('Acoustic Oak Slats', 'wall', 'Vertical FSC-certified oak timber acoustic paneling over sound-absorbing recycled felt.', 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=600&q=80', '#C5A07A', '€€€', TRUE),
('Venetian Stucco Microcement', 'wall', 'Seamless hand-troweled continuous waterproof coating with subtle polished mineral reflections.', 'https://images.unsplash.com/photo-1588854337221-4cf9fa96059c?auto=format&fit=crop&w=600&q=80', '#CFCBC6', '€€€', TRUE),
('Architectural Matte Paint (Warm Sand)', 'wall', 'Ultra-deep matte pigment finish, zero-VOC with superior light diffusion.', 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=600&q=80', '#D8C6B1', '€', TRUE),
('Textured Woven Linen Wallpaper', 'wall', 'Natural fibers woven backing imparting acoustic softness and tactile luxury.', 'https://images.unsplash.com/photo-1615529182904-14819c35db37?auto=format&fit=crop&w=600&q=80', '#DDD5C7', '€€', TRUE);

-- Materials (Floor)
INSERT INTO materials (name, category, description, image, color, price_range, active)
VALUES
('French Chevron Oak Parquet', 'floor', 'Solid French oak laid in classic 45-degree chevron pattern with matte invisible protective oil.', 'https://images.unsplash.com/photo-1581858726788-75bc0f6a952d?auto=format&fit=crop&w=600&q=80', '#B98A58', '€€€€', TRUE),
('Polished Calacatta Gold Marble', 'floor', 'Large-format porcelain slabs replicating Italian Calacatta gold veins.', 'https://images.unsplash.com/photo-1600585152220-90363fe7e115?auto=format&fit=crop&w=600&q=80', '#F2EFEB', '€€€€', TRUE),
('Continuous Architectural Concrete', 'floor', 'Seamless diamond-honed concrete floor with satin finish and underfloor heating compatibility.', 'https://images.unsplash.com/photo-1562663474-6cbb3eaa4d14?auto=format&fit=crop&w=600&q=80', '#A8A6A1', '€€€', TRUE),
('Wide Plank Natural Blonde Oak', 'floor', 'Extra-wide 240mm engineered planks brushed for tactile grain depth.', 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?auto=format&fit=crop&w=600&q=80', '#D6B78F', '€€€', TRUE),
('Large-Format Neutral Sandstone Porcelain', 'floor', '90x90cm rectified non-slip natural stone texture tiles for indoor-outdoor flow.', 'https://images.unsplash.com/photo-1616486029423-aaa4789e8c9a?auto=format&fit=crop&w=600&q=80', '#C4B7A5', '€€', TRUE);

-- Services
INSERT INTO services (name, description, image, active)
VALUES
('Complete Interior Renovation', 'Turnkey remodeling of apartments, villas, and boutique spaces with dedicated project management and master artisans.', 'https://images.unsplash.com/photo-1581858726788-75bc0f6a952d?auto=format&fit=crop&w=800&q=80', TRUE),
('Wall Coverings & Fine Plaster', 'Application of Venetian plaster, microcement, high-end wallpapers, and custom acoustic timber wall systems.', 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80', TRUE),
('Flooring & Parquet Mastery', 'Installation, restoration and treatment of chevron parquet, solid hardwoods, large-format stoneware and polished concrete.', 'https://images.unsplash.com/photo-1600585152220-90363fe7e115?auto=format&fit=crop&w=800&q=80', TRUE),
('Architectural Painting & Coatings', 'Meticulous surface preparation and spray/hand finishes using premium mineral and eco-certified paints.', 'https://images.unsplash.com/photo-1588854337221-4cf9fa96059c?auto=format&fit=crop&w=800&q=80', TRUE),
('Bespoke Architectural Lighting', 'Concealed coves, magnetic low-voltage tracks, and scene automation engineered for warmth and luxury.', 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=800&q=80', TRUE);

-- Showcase Projects
INSERT INTO projects (title, description, location, room_type, style, cover_image, before_image, after_image)
VALUES
('Haussmannian Living Room Reimagined', 'Transformation of a classic 19th-century Parisian living room with restored moldings, chevron oak parquet and contemporary bronze lighting.', 'Paris 8th, France', 'Living Room', 'Modern Luxury',
 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80',
 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1200&q=80'),

('Minimalist Loft Renovation', 'Complete overhaul of an outdated commercial loft into a serene open-concept living space with microcement floor and slatted wall.', 'Lyon Presqu''île, France', 'Living Room', 'Minimalist Warmth',
 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',
 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=1200&q=80',
 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80'),

('Master Suite & Bathroom Sanctuary', 'Dark cramped bedroom converted into an airy Scandinavian haven featuring natural oak, concealed cove lighting and linen curtains.', 'Bordeaux, France', 'Bedroom', 'Scandinavian Nordic',
 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80',
 'https://images.unsplash.com/photo-1562663474-6cbb3eaa4d14?auto=format&fit=crop&w=1200&q=80',
 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=1200&q=80');
