-- Create trips table
CREATE TABLE trips (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  destination TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  image_url TEXT NOT NULL
);

-- Create activities table with foreign key to trips
CREATE TABLE activities (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  is_completed BOOLEAN NOT NULL DEFAULT false,
  trip_id INTEGER NOT NULL REFERENCES trips(id) ON DELETE CASCADE
);

-- Enable real-time for both tables
ALTER PUBLICATION supabase_realtime ADD TABLE trips;
ALTER PUBLICATION supabase_realtime ADD TABLE activities;
