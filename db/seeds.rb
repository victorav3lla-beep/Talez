# TALEZ Seeds - Simplified Netflix-style Structure
# Run with: rails db:seed
# Reset with: rails db:reset

# NOTE: Current schema has circular dependencies (Characters/Universes belong_to Story,
# and Story belongs_to Character/Universe). This seeds file includes workarounds.

puts "Cleaning up existing data..."
Message.destroy_all
Chat.destroy_all
Like.destroy_all
Bookmark.destroy_all
StoryCharacter.destroy_all
StoryUniverse.destroy_all
Story.destroy_all
Character.destroy_all
Universe.destroy_all
Profile.destroy_all
User.destroy_all

# ═══════════════════════════════════════════════════════════════════════════════
# USERS (Netflix-style: Kid accounts + Guest)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating user accounts..."

lily_user = User.create!(
  email: "lily@example.com",
  password: "password123",
  password_confirmation: "password123"
)

max_user = User.create!(
  email: "max@example.com",
  password: "password123",
  password_confirmation: "password123"
)

sophie_user = User.create!(
  email: "sophie@example.com",
  password: "password123",
  password_confirmation: "password123"
)

guest_user = User.create!(
  email: "guest@example.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "Created #{User.count} users"

# ═══════════════════════════════════════════════════════════════════════════════
# PROFILES (3 per user - Netflix-style)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating profiles..."

# Lily's profiles
lily_profile1 = Profile.create!(
  user: lily_user,
  name: "Lily",
  age: 7,
  username: "lily_tales",
  avatar_url: "https://i.pravatar.cc/150?img=10"
)

lily_profile2 = Profile.create!(
  user: lily_user,
  name: "Lily's Adventure",
  age: 7,
  username: "lily_adventure",
  avatar_url: "https://i.pravatar.cc/150?img=11"
)

lily_profile3 = Profile.create!(
  user: lily_user,
  name: "Lily's Magic",
  age: 7,
  username: "lily_magic",
  avatar_url: "https://i.pravatar.cc/150?img=12"
)

# Max's profiles
max_profile1 = Profile.create!(
  user: max_user,
  name: "Max",
  age: 9,
  username: "max_explorer",
  avatar_url: "https://i.pravatar.cc/150?img=13"
)

max_profile2 = Profile.create!(
  user: max_user,
  name: "Max's World",
  age: 9,
  username: "max_world",
  avatar_url: "https://i.pravatar.cc/150?img=14"
)

max_profile3 = Profile.create!(
  user: max_user,
  name: "Max's Stories",
  age: 9,
  username: "max_stories",
  avatar_url: "https://i.pravatar.cc/150?img=15"
)

# Sophie's profiles
sophie_profile1 = Profile.create!(
  user: sophie_user,
  name: "Sophie",
  age: 5,
  username: "sophie_dreamer",
  avatar_url: "https://i.pravatar.cc/150?img=20"
)

sophie_profile2 = Profile.create!(
  user: sophie_user,
  name: "Sophie's Fun",
  age: 5,
  username: "sophie_fun",
  avatar_url: "https://i.pravatar.cc/150?img=21"
)

sophie_profile3 = Profile.create!(
  user: sophie_user,
  name: "Sophie's Friends",
  age: 5,
  username: "sophie_friends",
  avatar_url: "https://i.pravatar.cc/150?img=22"
)

# Guest profile
guest_profile = Profile.create!(
  user: guest_user,
  name: "Guest",
  age: 8,
  username: "guest_user",
  avatar_url: "https://i.pravatar.cc/150?img=30"
)

all_profiles = [lily_profile1, lily_profile2, lily_profile3,
                max_profile1, max_profile2, max_profile3,
                sophie_profile1, sophie_profile2, sophie_profile3,
                guest_profile]

puts "Created #{Profile.count} profiles"

# ═══════════════════════════════════════════════════════════════════════════════
# DEFAULT CHARACTERS (3 only + ability to create custom)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating default characters..."

# Workaround for circular dependency: create temp story first
temp_story = Story.create!(
  profile: lily_profile1,
  title: "Temp",
  content: "Temp",
  public: false
)

default_char1 = Character.create!(
  name: "Sparkle the Fairy",
  details: "A kind fairy with rainbow wings who spreads joy wherever she goes",
  image: "https://placehold.co/300x400/f39c12/white?text=Sparkle+Fairy",
  story: temp_story
)

default_char2 = Character.create!(
  name: "Captain Stella",
  details: "A brave superhero who can fly through the stars and helps friends",
  image: "https://placehold.co/300x400/e74c3c/white?text=Captain+Stella",
  story: temp_story
)

default_char3 = Character.create!(
  name: "Blaze the Dragon",
  details: "A gentle dragon who loves telling stories by the campfire",
  image: "https://placehold.co/300x400/d35400/white?text=Blaze+Dragon",
  story: temp_story
)

temp_story.destroy!

default_characters = [default_char1, default_char2, default_char3]
puts "Created #{default_characters.count} default characters"

# ═══════════════════════════════════════════════════════════════════════════════
# DEFAULT UNIVERSES (3 only + ability to create custom)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating default universes..."

temp_story = Story.create!(
  profile: lily_profile1,
  title: "Temp",
  content: "Temp",
  public: false
)

default_univ1 = Universe.create!(
  name: "Enchanted Forest",
  details: "A magical woodland with talking animals and glowing mushrooms",
  image: "https://placehold.co/400x300/27ae60/white?text=Enchanted+Forest",
  story: temp_story
)

default_univ2 = Universe.create!(
  name: "Space Station Alpha",
  details: "A floating home among the stars with zero gravity rooms",
  image: "https://placehold.co/400x300/3498db/white?text=Space+Station",
  story: temp_story
)

default_univ3 = Universe.create!(
  name: "Dragonstone Castle",
  details: "A medieval fortress with tall towers and secret passages",
  image: "https://placehold.co/400x300/7f8c8d/white?text=Castle",
  story: temp_story
)

temp_story.destroy!

default_universes = [default_univ1, default_univ2, default_univ3]
puts "Created #{default_universes.count} default universes"

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM CHARACTERS (2 total - created by kids)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating custom characters..."

temp_story1 = Story.create!(
  profile: lily_profile1,
  title: "Temp",
  content: "Temp",
  public: false
)

custom_char1 = Character.create!(
  name: "Glitter Unicorn",
  details: "A unicorn that leaves glitter trails and loves cupcakes",
  image: "https://placehold.co/300x400/ff6b9d/white?text=Glitter+Unicorn",
  story: temp_story1
)

temp_story1.destroy!

temp_story2 = Story.create!(
  profile: max_profile1,
  title: "Temp",
  content: "Temp",
  public: false
)

custom_char2 = Character.create!(
  name: "Thunder Knight",
  details: "A warrior with lightning powers and electric armor",
  image: "https://placehold.co/300x400/4b6584/white?text=Thunder+Knight",
  story: temp_story2
)

temp_story2.destroy!

custom_characters = [custom_char1, custom_char2]
puts "Created #{custom_characters.count} custom characters"

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM UNIVERSES (2 total - created by kids)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating custom universes..."

temp_story1 = Story.create!(
  profile: lily_profile1,
  title: "Temp",
  content: "Temp",
  public: false
)

custom_univ1 = Universe.create!(
  name: "Rainbow Valley",
  details: "A magical valley where everything is colorful and flowers sing",
  image: "https://placehold.co/400x300/fd79a8/white?text=Rainbow+Valley",
  story: temp_story1
)

temp_story1.destroy!

temp_story2 = Story.create!(
  profile: max_profile1,
  title: "Temp",
  content: "Temp",
  public: false
)

custom_univ2 = Universe.create!(
  name: "Thunder Stadium",
  details: "A massive sports arena where legendary games are played",
  image: "https://placehold.co/400x300/0984e3/white?text=Thunder+Stadium",
  story: temp_story2
)

temp_story2.destroy!

custom_universes = [custom_univ1, custom_univ2]
puts "Created #{custom_universes.count} custom universes"

# ═══════════════════════════════════════════════════════════════════════════════
# STORIES (2 total)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating stories..."

story1 = Story.create!(
  profile: lily_profile1,
  title: "The Sparkle Fairy's First Day",
  content: "Sparkle woke up in the Enchanted Forest and decided to make new friends. She flew through the trees, leaving a trail of rainbow dust...",
  public: true,
  character: default_char1,
  universes: default_univ1
)

story2 = Story.create!(
  profile: max_profile1,
  title: "Thunder Knight Saves the Day",
  content: "When dark clouds covered the Thunder Stadium, Thunder Knight knew something was wrong. He grabbed his electric sword and ran to help...",
  public: true,
  character: custom_char2,
  universes: custom_univ2
)

all_stories = [story1, story2]
puts "Created #{Story.count} stories"

# ═══════════════════════════════════════════════════════════════════════════════
# LIKES & BOOKMARKS
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating likes and bookmarks..."

# Story 1 gets likes from some profiles
[max_profile1, sophie_profile1, guest_profile].each do |profile|
  Like.create!(story: story1, profile: profile)
end

# Story 2 gets likes from different profiles
[lily_profile1, sophie_profile2, max_profile2].each do |profile|
  Like.create!(story: story2, profile: profile)
end

# Add bookmarks (subset of likes)
Bookmark.create!(story: story1, profile: max_profile1)
Bookmark.create!(story: story1, profile: guest_profile)
Bookmark.create!(story: story2, profile: lily_profile1)

puts "Created #{Like.count} likes"
puts "Created #{Bookmark.count} bookmarks"

# ═══════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════════

puts "\n" + ("=" * 60)
puts "TALEZ DATABASE SEEDED SUCCESSFULLY"
puts "=" * 60
puts "\nSummary:"
puts "  Users:              #{User.count} (3 kids + 1 guest)"
puts "  Profiles:           #{Profile.count} (3 per user)"
puts "  Characters:         #{Character.count}"
puts "    - Default:        #{default_characters.count}"
puts "    - Custom:         #{custom_characters.count}"
puts "  Universes:          #{Universe.count}"
puts "    - Default:        #{default_universes.count}"
puts "    - Custom:         #{custom_universes.count}"
puts "  Stories:            #{Story.count}"
puts "    - Public:         #{Story.where(public: true).count}"
puts "    - Private:        #{Story.where(public: false).count}"
puts "  Likes:              #{Like.count}"
puts "  Bookmarks:          #{Bookmark.count}"
puts "\nLogin Credentials:"
puts "  lily@example.com / password123"
puts "  max@example.com / password123"
puts "  sophie@example.com / password123"
puts "  guest@example.com / password123"
puts "\n" + ("=" * 60)
