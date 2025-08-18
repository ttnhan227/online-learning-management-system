-- Add new columns to course table
ALTER TABLE course 
    ADD COLUMN category VARCHAR(100),
    ADD COLUMN image_url VARCHAR(255),
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- Add last_accessed column to enrollment table
ALTER TABLE enrollment
    ADD COLUMN last_accessed TIMESTAMP;
