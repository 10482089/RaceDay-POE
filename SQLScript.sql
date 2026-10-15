-- =============================================
-- DATABASE: RaceDayDB
-- This creates the entire RaceDay database
-- =============================================

-- Create the database (delete it if it exists)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'RaceDayDB')
BEGIN
    DROP DATABASE RaceDayDB;
END
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

-- =============================================
-- TABLE 1: User
-- Stores both Organisers and Participants
-- =============================================
CREATE TABLE [User] (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Organiser', 'Participant')),
    ProfilePictureURL NVARCHAR(500) NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- =============================================
-- TABLE 2: EventType
-- Run, Walk, Cycle
-- =============================================
CREATE TABLE EventType (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(20) NOT NULL UNIQUE,
    Description NVARCHAR(200) NULL
);
GO

-- =============================================
-- TABLE 3: Event
-- Stores all events/races
-- =============================================
CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventTypeID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    [Date] DATETIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Distance DECIMAL(5,2) NOT NULL,
    BannerImageURL NVARCHAR(500) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    
    -- Foreign Keys
    FOREIGN KEY (OrganiserID) REFERENCES [User](UserID),
    FOREIGN KEY (EventTypeID) REFERENCES EventType(EventTypeID)
);
GO

-- =============================================
-- TABLE 4: Category
-- Age or distance categories for events
-- =============================================
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);
GO

-- =============================================
-- TABLE 5: Enrolment
-- Links Participant -> Event -> Category
-- =============================================
CREATE TABLE Enrolment (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending' 
        CHECK (Status IN ('Confirmed', 'Pending', 'Cancelled')),
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (ParticipantID) REFERENCES [User](UserID),
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    
    -- One participant can only enrol once per event
    CONSTRAINT UQ_Enrolment UNIQUE (ParticipantID, EventID)
);
GO

-- =============================================
-- TABLE 6: Result
-- Participant finish times and positions
-- =============================================
CREATE TABLE [Result] (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL,
    FinishTime TIME NOT NULL,
    FinishingPosition INT NOT NULL,
    TotalFinishers INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolment(EnrolmentID)
);
GO

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- Insert Event Types
INSERT INTO EventType (TypeName, Description) VALUES 
('Run', 'Running events and races'),
('Walk', 'Walking events and fun walks'),
('Cycle', 'Cycling events and tours');
GO

-- Insert Sample Organiser
INSERT INTO [User] (Email, PasswordHash, FirstName, LastName, Role) 
VALUES 
('organiser@raceday.com', 'dummy_hash_123', 'Thabo', 'Mokoena', 'Organiser');

-- Insert Sample Participant
INSERT INTO [User] (Email, PasswordHash, FirstName, LastName, Role) 
VALUES 
('participant@raceday.com', 'dummy_hash_456', 'Lerato', 'Ndlovu', 'Participant');
GO

-- Create a Sample Event
INSERT INTO Event (OrganiserID, EventTypeID, Name, Description, [Date], Location, Distance)
VALUES 
(1, 1, 'Soweto Marathon 2026', 'Annual Soweto Marathon - The People\'s Race', 
 '2026-11-15 06:00:00', 'Soweto, Johannesburg', 42.20);

-- Add Categories for the Event
INSERT INTO Category (EventID, Name, Description)
VALUES 
(1, 'Under 20', 'For participants under 20 years old'),
(1, 'Senior (20-39)', 'For participants aged 20-39'),
(1, 'Master (40+)', 'For participants aged 40 and above');

-- Enrol the Participant in the Event
INSERT INTO Enrolment (ParticipantID, EventID, CategoryID, Status)
VALUES 
(2, 1, 2, 'Confirmed');

-- Add a Result for the Participant
INSERT INTO [Result] (EnrolmentID, FinishTime, FinishingPosition, TotalFinishers)
VALUES 
(1, '03:45:30', 47, 312);

-- Show what's in the database
SELECT 'Users' AS TableName, UserID, Email, FirstName, LastName, Role FROM [User];
SELECT 'Events' AS TableName, EventID, Name, Date, Location FROM Event;
SELECT 'Enrolments' AS TableName, EnrolmentID, Status FROM Enrolment;