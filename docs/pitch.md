## 1. PROJECT SUMMARY

### Project Title:

Lagaw: AI-Powered Personalized Travel Recommendation and Itinerary Planning System for Bacolod City

### Project Description:

Lagaw is a Flutter-based Android application, with a companion web build, providing visual, swipe-based travel recommendations for Bacolod residents, tourists, students, families, couples, and other travelers exploring Bacolod City. Users swipe right on destinations they like, swipe left on destinations they are not interested in, save locations, and rate places they have visited. Lagaw combines these interactions with the user’s budget and preferred travel tags to recommend destinations that match their interests. The system then arranges suitable locations into a personalized itinerary while considering operating hours, travel distance, estimated cost, and visit duration. Lagaw addresses the decision fatigue caused by generic tourism lists and repetitive manual searching by giving each user recommendations based on their actual preferences and behavior.

### Core Resource:

The main CRUD resource is the Trip. Users can:

- Create a trip using their dates, budget, preferences, and travel constraints

- View the generated itinerary

- Update trip details and selected destinations

- Delete or archive previous trips

Locations will be maintained as administrator-managed records used by the recommendation system.

## 2. AI FEATURE JUSTIFICATION

### Primary AI Feature

Lagaw’s primary AI feature is a hybrid recommendation system that combines:

- Collaborative filtering through matrix factorization

- Content-based filtering

- User preference ranking

The system uses swipes, saves, ratings, selected tags, and budget preferences to predict which Bacolod destinations a user is most likely to enjoy.

The recommendation system runs locally through the Python backend and does not depend on a cloud LLM or autonomous cloud agent.

### Required AI Integration Category

Lagaw’s LLM-related feature falls under structured output extraction.

A hosted Google Gemini language model, called only through the Python backend, will convert natural-language travel requests into structured trip preferences.

For example, the user may enter:

“I want a cheap and relaxing afternoon with coffee and photography spots.”

The hosted model may extract:

- Budget level: Low

- Preferred tags: Café, photography, relaxing

- Trip duration: Afternoon

- Preferred pace: Slow

This structured extraction feature supports the recommendation system but does not generate the recommendations itself. The hybrid recommendation model remains the primary AI feature.

### What the AI Does

The recommendation model creates a user-location interaction matrix based on swipes, saves, and ratings.

Matrix factorization identifies hidden preference patterns between users and locations. For example, if users with similar behavior frequently like heritage sites, quiet cafés, and photography locations, Lagaw can recommend related destinations that the current user has not yet seen.

Content-based filtering compares the user’s selected preferences with destination information such as:

- Category and travel tags

- Estimated cost

- Suitable group type

- Indoor or outdoor classification

- Typical visit duration

- Accessibility information

The final recommendation score combines collaborative filtering and content-based similarity.

For new users with limited interaction history, the system relies more heavily on selected tags, budget, and location attributes. As the user produces more swipes, saves, and ratings, collaborative filtering becomes more influential.

### Backend Processing of AI Output

The AI output will not be passed directly to the frontend.

For structured preference extraction, the backend will:

- Validate the output against a predefined schema

- Match extracted tags with approved database tags

- Reject unsupported values

- Validate budget and trip duration fields

- Apply default values when appropriate

- Store only the validated preferences

For recommendation scores, the backend will:

- Normalize and combine collaborative and content-based scores

- Confirm that recommended locations exist in the database

- Remove inactive, duplicate, rejected, or incompatible locations

- Apply budget, group, accessibility, and distance filters

- Store the selected recommendation results

- Pass approved locations to the itinerary planner

The itinerary planner will then arrange the recommended destinations while checking operating hours, travel time, estimated cost, and schedule conflicts.

Only validated recommendations and itineraries will be returned to the frontend.

### AI Provider and Deployment

Primary recommendation model:

- Provider: Self-developed Python recommendation model

- Deployment: Local or self-hosted backend

- Libraries: pandas, NumPy, scikit-learn, and LightFM or an equivalent matrix factorization library

Structured output extraction:

- Provider: Google Gemini Developer API

- Deployment: Cloud-hosted; accessed only through the Python backend

- Model: `gemini-3.5-flash-lite` (configurable via environment variable)

Sprint 1 will confirm provider credentials and connectivity through a single backend test call. Gemini extracts structured preferences; the self-developed Python model remains responsible for recommendations.

## 3. DATABASE SCHEMA SKETCH

### Users Table

Fields:

- id (UUID, primary key)

- name (text)

- email (text)

- traveler_type (text)

- preferred_tags: array or JSON

- default_budget_min: decimal

- default_budget_max: decimal

- created_at: timestamp

### locations

Fields:

- id: UUID, primary key

- name: text

- description: text

- category: text

- vibe_tags: array or JSON

- address: text

- latitude: decimal

- longitude: decimal

- opening_hours: JSON

- estimated_cost_min: decimal

- estimated_cost_max: decimal

- typical_visit_duration: integer

- suitable_group_types: array or JSON

- image_url: text

- is_active: boolean

### user_location_interactions

Fields:

- id: UUID, primary key

- user_id: UUID, foreign key referencing users.id

- location_id: UUID, foreign key referencing locations.id

- interaction_type: text

- interaction_value: decimal

- rating_value: decimal, nullable

- created_at: timestamp

Possible interaction types include left swipe, right swipe, save, and rating.

### trips

Fields:

- id: UUID, primary key

- user_id: UUID, foreign key referencing users.id

- title: text

- start_date: date

- end_date: date

- budget_min: decimal

- budget_max: decimal

- transportation_mode: text

- group_type: text

- preferred_tags: array or JSON

- status: text

- estimated_total_cost: decimal

### itinerary_items

Fields:

- id: UUID, primary key

- trip_id: UUID, foreign key referencing trips.id

- location_id: UUID, foreign key referencing locations.id

- day_number: integer

- visit_order: integer

- arrival_time: time

- departure_time: time

- estimated_travel_time: integer

- estimated_cost: decimal

- recommendation_score: decimal

- recommendation_reason: text

### Relationships

- One user can have many trips.

- One user can have many location interactions.

- One location can receive interactions from many users.

- One trip can contain many itinerary items.

- Each itinerary item references one location.

### Simple Relationship Outline
```text
users

├── trips

│ └── itinerary_items

│ └── locations

│

└── user_location_interactions

└── locations
```

## 4. TECH STACK DECLARATION

### Frontend

- Flutter (Dart)

- Android application as the primary platform

- Flutter Web build from the same codebase for browser access and live demonstrations

### Backend

- FastAPI

- Python

### Database

- PostgreSQL through Supabase

### AI Provider and SDK

- pandas, NumPy, scikit-learn, and LightFM for the recommendation system

- Google Gemini API (`google-genai` Python SDK) for hosted structured output extraction

### Hosting Plan

- Android app: Flutter Android APK build, distributed for testing

- Public frontend URL: Flutter Web build hosted on Cloudflare Pages or Netlify, deployed automatically from the main branch through CI/CD

- Backend: Render, Railway, or another Python-compatible platform

- Database and storage: Supabase

The Android application is the primary product; its Flutter Web counterpart provides the required live URL using the same codebase and backend API. The final hosting provider may change depending on available resources and deployment requirements.

## 5. RISK AND FEASIBILITY SELF-CHECK

### What is the riskiest technical part of this project personally, and why?

The riskiest technical part is creating useful collaborative filtering recommendations with limited real-user interaction data.

Matrix factorization normally performs better when many users have interacted with many destinations. During early development, Lagaw will have only a small number of real users.

The initial dataset will therefore include synthetic interactions based on travel personas such as budget travelers, café hoppers, heritage enthusiasts, food travelers, families, and photography-focused travelers.

These synthetic interactions will be used for development and testing. Real swipe, save, and rating data will also be collected from classmates, friends, and volunteer testers.

### What is the fallback if the AI feature proves harder than expected?

If matrix factorization does not produce reliable results, Lagaw will use a weighted content-based recommendation system.

The fallback model will rank destinations using:

- Similarity between user tags and location tags

- Budget compatibility

- Preferred categories

- Group suitability

- Ratings

- Geographic distance

This keeps the personalized recommendation feature while reducing the amount of training data required.

If hosted structured output extraction is unavailable or unreliable, users will enter their preferences through the standard trip form instead.

### Do you already have API access or keys for the chosen AI provider?

A Gemini Developer API key is required for hosted preference extraction.

The primary recommendation model will run through the Python backend; Gemini will be called from the backend only.

The team will still need to configure Supabase credentials and possibly a routing service key.

## 6. ENVIRONMENT PLAN

The project will use a .env file to store real credentials and environment-specific configuration.

The .env file will not be committed to version control and will be included in .gitignore.

The repository will include a .env.example file containing variable names and placeholder values only.

Expected secrets include:

- DATABASE_URL

- SUPABASE_URL

- SUPABASE_ANON_KEY

- SUPABASE_SERVICE_ROLE_KEY

- SESSION_SECRET

- JWT_SECRET, if custom authentication is used

- ROUTING_API_KEY, if the selected routing service requires one

- GEMINI_API_KEY

Local configuration values may include:

- GEMINI_MODEL (for example, `gemini-3.5-flash-lite`)

- MODEL_FILE_PATH (for the self-developed recommender, if needed)

- API_BASE_URL (public Flutter API endpoint, supplied at build time for web/Android builds)

- WEB_APP_URL

No database passwords, service-role keys, authentication secrets, or private credentials will be hardcoded into the source code.
