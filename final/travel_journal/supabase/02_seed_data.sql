-- Seed trips data
INSERT INTO trips (name, destination, start_date, end_date, image_url) VALUES
('Summer in Paris', 'Paris, France', '2024-06-15', '2024-06-25', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400'),
('Tokyo Adventure', 'Tokyo, Japan', '2024-07-10', '2024-07-20', 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400'),
('Safari in Kenya', 'Nairobi, Kenya', '2024-08-05', '2024-08-15', 'https://images.unsplash.com/photo-1489392191049-fc10c97e64b6?w=400'),
('New York City Break', 'New York, USA', '2024-09-01', '2024-09-07', 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400'),
('Greek Islands', 'Santorini, Greece', '2024-10-10', '2024-10-20', 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400');

-- Seed activities data
INSERT INTO activities (title, description, is_completed, trip_id) VALUES
('Visit Eiffel Tower', 'Take photos from the top', true, 1),
('Louvre Museum', 'See the Mona Lisa', true, 1),
('Seine River Cruise', 'Evening dinner cruise', false, 1),
('Visit Senso-ji Temple', 'Explore the oldest temple in Tokyo', true, 2),
('Shibuya Crossing', 'Experience the busiest crossing', true, 2),
('Mount Fuji Day Trip', 'See the iconic mountain', false, 2),
('Tsukiji Fish Market', 'Fresh sushi breakfast', false, 2),
('Masai Mara Safari', 'Big five game drive', true, 3),
('Visit Giraffe Centre', 'Feed the giraffes', false, 3),
('Empire State Building', 'Visit observation deck', true, 4),
('Central Park Walk', 'Morning jog in the park', false, 4),
('Broadway Show', 'Watch a musical', false, 4),
('Sunset in Oia', 'Famous sunset views', true, 5),
('Beach Day', 'Relax at Red Beach', false, 5);
