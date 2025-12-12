require "open-uri"
# TALEZ Seeds - Netflix-style Structure
# Run with: rails db:seed
# Reset with: rails db:reset

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
# USERS (Netflix-style: 3 kid accounts + 1 guest)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating user accounts..."

lily = User.create!(
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
# PROFILES (3 per user)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating profiles..."

# Lily's profiles
lily_profile1 = Profile.create!(
  user: lily,
  name: "Olivier",
  age: 7,
  username: "Olivier"
  # avatar_url: "https://i.pravatar.cc/150?img=10"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280271/anime-away-face-svgrepo-com_zqihw4.png").open
  lily_profile1.image.attach(io: file, filename: "lily_1.png", content_type: "image/png")

lily_profile2 = Profile.create!(
  user: lily,
  name: "Luis",
  age: 7,
  username: "Luis",
  # avatar_url: "https://i.pravatar.cc/150?img=11"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280071/avatar-avocado-food-svgrepo-com_fkxp3n.png").open
  lily_profile2.image.attach(io: file, filename: "lily_adventure.png", content_type: "image/png")

lily_profile3 = Profile.create!(
  user: lily,
  name: "soojin",
  age: 7,
  username: "Soojin",
  # avatar_url: "https://i.pravatar.cc/150?img=12"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765539119/cute-snail-with-ice-cream-cone_jts3bo.avif").open
  lily_profile3.image.attach(io: file, filename: "lily_magic.png", content_type: "image/png")

# Max's profiles
max_profile1 = Profile.create!(
  user: max_user,
  name: "Max",
  age: 9,
  username: "max_explorer",
  # avatar_url: "https://i.pravatar.cc/150?img=13"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280271/anime-away-face-svgrepo-com_zqihw4.png").open
  max_profile1.image.attach(io: file, filename: "max_1.png", content_type: "image/png")

max_profile2 = Profile.create!(
  user: max_user,
  name: "Max's World",
  age: 9,
  username: "max_world",
  # avatar_url: "https://i.pravatar.cc/150?img=14"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280071/avatar-avocado-food-svgrepo-com_fkxp3n.png").open
  max_profile2.image.attach(io: file, filename: "max_world.png", content_type: "image/png")

max_profile3 = Profile.create!(
  user: max_user,
  name: "Max's Stories",
  age: 9,
  username: "max_stories",
  # avatar_url: "https://i.pravatar.cc/150?img=15"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280071/avatar-cloud-crying-svgrepo-com_wzugrv.png").open
  max_profile3.image.attach(io: file, filename: "max_stories.png", content_type: "image/png")

# Sophie's profiles
sophie_profile1 = Profile.create!(
  user: sophie_user,
  name: "Sophie",
  age: 5,
  username: "sophie_dreamer",
  # avatar_url: "https://i.pravatar.cc/150?img=20"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280271/anime-away-face-svgrepo-com_zqihw4.png").open
  sophie_profile1.image.attach(io: file, filename: "sophie  _1.png", content_type: "image/png")

sophie_profile2 = Profile.create!(
  user: sophie_user,
  name: "Sophie's Fun",
  age: 5,
  username: "sophie_fun",
  # avatar_url: "https://i.pravatar.cc/150?img=21"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280071/avatar-avocado-food-svgrepo-com_fkxp3n.png").open
  sophie_profile2.image.attach(io: file, filename: "sophie_fun.png", content_type: "image/png")

sophie_profile3 = Profile.create!(
  user: sophie_user,
  name: "Sophie's Friends",
  age: 5,
  username: "sophie_friends",
  # avatar_url: "https://i.pravatar.cc/150?img=22"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280071/avatar-cloud-crying-svgrepo-com_wzugrv.png").open
  sophie_profile3.image.attach(io: file, filename: "sophie_friends.png", content_type: "image/png")

# Guest profile
guest_profile = Profile.create!(
  user: guest_user,
  name: "Guest",
  age: 8,
  username: "guest_user",
  #avatar_url: "https://i.pravatar.cc/150?img=30"
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765280271/avatar-cacti-cactus-svgrepo-com_1_a34edx.png").open
  guest_profile.image.attach(io: file, filename: "guest.png", content_type: "image/png")

all_profiles = [lily_profile1, lily_profile2, lily_profile3,
                max_profile1, max_profile2, max_profile3,
                sophie_profile1, sophie_profile2, sophie_profile3,
                guest_profile]

puts "Created #{Profile.count} profiles"

# ═══════════════════════════════════════════════════════════════════════════════
# DEFAULT CHARACTERS (Global TALEZ characters - profile_id is NULL)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating default TALEZ characters..."

default_char1 = Character.create!(
  name: "Sparkle the Fairy",
  description: "A kind fairy with rainbow wings who spreads joy wherever she goes",
  # image_url: "https://placehold.co/300x400/f39c12/white?text=Sparkle+Fairy",
  profile_id: nil,
  is_custom: false
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276387/sparkle_fairy_profile_s8kwdv.jpg").open
  default_char1.image.attach(io: file, filename: "sparkle.png", content_type: "image/png")

default_char2 = Character.create!(
  name: "Blaze the Dragon",
  description: "A gentle dragon who loves telling stories by the campfire",
  # image_url: "https://placehold.co/300x400/e74c3c/white?text=Captain+Stella",
  profile_id: nil,
  is_custom: false
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276395/blaze_dragon_profile_ayrfek.jpg").open
  default_char2.image.attach(io: file, filename: "blaze_dragon.png", content_type: "image/png")

  default_char3 = Character.create!(
    name: "Captain Stella",
    description: "A brave superhero who can fly through the stars and helps friends",
    # image_url: "https://placehold.co/300x400/d35400/white?text=Blaze+Dragon",
    profile_id: nil,
    is_custom: false
    )
    file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276388/captain_stella_profile_pxvvuo.jpg").open
    default_char3.image.attach(io: file, filename: "captain_stella.png", content_type: "image/png")

default_characters = [default_char1, default_char2, default_char3]
puts "Created #{default_characters.count} default characters"

# ═══════════════════════════════════════════════════════════════════════════════
# DEFAULT UNIVERSES (Global TALEZ universes - profile_id is NULL)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating default TALEZ universes..."

default_univ1 = Universe.create!(
  name: "Enchanted Forest",
  description: "A magical woodland filled with ancient trees and wonder!",
  # image_url: "https://placehold.co/400x300/27ae60/white?text=Enchanted+Forest",
  profile_id: nil,
  is_custom: false
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/enchanted_forest_fh0qbt.jpg").open
  default_univ1.image.attach(io: file, filename: "forest.png", content_type: "image/png")

default_univ2 = Universe.create!(
  name: "Galaxy Beyond",
  description: "A vast cosmos of stars, planets, and endless adventures!",
  # image_url: "https://placehold.co/400x300/3498db/white?text=Space+Station",
  profile_id: nil,
  is_custom: false
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/galaxy_beyond_xtdyro.jpg").open
  default_univ2.image.attach(io: file, filename: "galaxy_beyond.png", content_type: "image/png")

default_univ3 = Universe.create!(
  name: "Future City",
  description: "A bustling metropolis of technology and innovation!",
  # image_url: "https://placehold.co/400x300/7f8c8d/white?text=Castle",
  profile_id: nil,
  is_custom: false
  )
  file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/future_city_byjrpl.jpg").open
  default_univ3.image.attach(io: file, filename: "future_city.png", content_type: "image/png")

default_universes = [default_univ1, default_univ2, default_univ3]
puts "Created #{default_universes.count} default universes"

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM CHARACTERS (Created by kids - linked to profiles)
# ═══════════════════════════════════════════════════════════════════════════════

# puts "Creating custom characters..."

# custom_char1 = Character.create!(
#   name: "Glitter Unicorn",
#   description: "A unicorn that leaves glitter trails and loves cupcakes",
#   # image_url: "https://placehold.co/300x400/ff6b9d/white?text=Glitter+Unicorn",
#   file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/future_city_byjrpl.jpg").open,
#   default_univ3.image.attach(io: file, filename: "future_city.png", content_type: "image/png"),
#   profile_id: lily_profile1.id,
#   is_custom: true
# )

# custom_char2 = Character.create!(
#   name: "Thunder Knight",
#   description: "A warrior with lightning powers and electric armor",
#   # image_url: "https://placehold.co/300x400/4b6584/white?text=Thunder+Knight",
#   profile_id: max_profile1.id,
#   is_custom: true
# )

# custom_characters = [custom_char1, custom_char2]
# puts "Created #{custom_characters.count} custom characters"

# # ═══════════════════════════════════════════════════════════════════════════════
# # CUSTOM UNIVERSES (Created by kids - linked to profiles)
# # ═══════════════════════════════════════════════════════════════════════════════

# puts "Creating custom universes..."

# custom_univ1 = Universe.create!(
#   name: "Rainbow Valley",
#   description: "A magical valley where everything is colorful and flowers sing",
#   # image_url: "https://placehold.co/400x300/fd79a8/white?text=Rainbow+Valley",
#   profile_id: lily_profile1.id,
#   is_custom: true
# )

# custom_univ2 = Universe.create!(
#   name: "Thunder Stadium",
#   description: "A massive sports arena where legendary games are played",
#   # image_url: "https://placehold.co/400x300/0984e3/white?text=Thunder+Stadium",
#   profile_id: max_profile1.id,
#   is_custom: true
# )

# custom_universes = [custom_univ1, custom_univ2]
# puts "Created #{custom_universes.count} custom universes"

# ═══════════════════════════════════════════════════════════════════════════════
# STORIES (Using existing characters and universes)
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating stories..."

# Story 1: Sparkle Fairy's Adventure (by Lily)
story1 = Story.create!(
  profile_id: lily_profile1.id,
  title: "The Sparkle Fairy's First Day",
  content: "Sparkle woke up in the Enchanted Forest and decided to make new friends.",
  public: true,
  status: "published",
  likes_count: 0
)
# Attach cover
cover_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/enchanted_forest_fh0qbt.jpg").open
story1.cover.attach(io: cover_file, filename: "story1_cover.jpg", content_type: "image/jpeg")

# Pages for Story 1
page1_1 = story1.pages.create!(
  title: "The Beginning",
  content: "Sparkle the Fairy woke up in the magical Enchanted Forest. The sun was shining through the ancient trees, and everything glowed with wonder.",
  position: 1
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/enchanted_forest_fh0qbt.jpg").open
page1_1.image.attach(io: page_file, filename: "page1_1.jpg", content_type: "image/jpeg")

page1_2 = story1.pages.create!(
  title: "Making Friends",
  content: "Sparkle flew through the trees, leaving a trail of rainbow dust. She met a friendly squirrel named Nutty who wanted to join her adventure!",
  position: 2
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276387/sparkle_fairy_profile_s8kwdv.jpg").open
page1_2.image.attach(io: page_file, filename: "page1_2.jpg", content_type: "image/jpeg")

page1_3 = story1.pages.create!(
  title: "The Happy Ending",
  content: "Together, Sparkle and Nutty discovered a hidden waterfall with magical crystals. They became best friends forever!",
  position: 3
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/enchanted_forest_fh0qbt.jpg").open
page1_3.image.attach(io: page_file, filename: "page1_3.jpg", content_type: "image/jpeg")

# Story 2: Dragon's Quest (by Max)
story2 = Story.create!(
  profile_id: max_profile1.id,
  title: "Blaze's Space Adventure",
  content: "Blaze the Dragon discovers a rocket ship and goes to space!",
  public: true,
  status: "published",
  likes_count: 0
)
cover_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/galaxy_beyond_xtdyro.jpg").open
story2.cover.attach(io: cover_file, filename: "story2_cover.jpg", content_type: "image/jpeg")

page2_1 = story2.pages.create!(
  title: "Discovery",
  content: "Blaze the Dragon found a shiny rocket ship hidden behind the mountains. He had always dreamed of visiting the stars!",
  position: 1
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276395/blaze_dragon_profile_ayrfek.jpg").open
page2_1.image.attach(io: page_file, filename: "page2_1.jpg", content_type: "image/jpeg")

page2_2 = story2.pages.create!(
  title: "Blast Off!",
  content: "With a mighty roar, Blaze climbed into the rocket. 3... 2... 1... BLAST OFF! The rocket zoomed into the galaxy beyond!",
  position: 2
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/galaxy_beyond_xtdyro.jpg").open
page2_2.image.attach(io: page_file, filename: "page2_2.jpg", content_type: "image/jpeg")

page2_3 = story2.pages.create!(
  title: "Space Friends",
  content: "In space, Blaze met friendly aliens who loved his fire tricks. They had a cosmic party under the stars!",
  position: 3
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/galaxy_beyond_xtdyro.jpg").open
page2_3.image.attach(io: page_file, filename: "page2_3.jpg", content_type: "image/jpeg")

# Story 3: Captain Stella's Mission (by Sophie)
story3 = Story.create!(
  profile_id: sophie_profile1.id,
  title: "Captain Stella Saves the City",
  content: "Captain Stella uses her powers to help everyone in Future City!",
  public: true,
  status: "published",
  likes_count: 0
)
cover_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/future_city_byjrpl.jpg").open
story3.cover.attach(io: cover_file, filename: "story3_cover.jpg", content_type: "image/jpeg")

page3_1 = story3.pages.create!(
  title: "The Call",
  content: "Captain Stella heard a loud alarm in Future City. Someone needed help! She flew into the sky immediately.",
  position: 1
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276388/captain_stella_profile_pxvvuo.jpg").open
page3_1.image.attach(io: page_file, filename: "page3_1.jpg", content_type: "image/jpeg")

page3_2 = story3.pages.create!(
  title: "To the Rescue",
  content: "A kitten was stuck on top of the tallest building! Captain Stella swooped down and gently carried it to safety.",
  position: 2
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/future_city_byjrpl.jpg").open
page3_2.image.attach(io: page_file, filename: "page3_2.jpg", content_type: "image/jpeg")

page3_3 = story3.pages.create!(
  title: "Hero's Welcome",
  content: "Everyone in Future City cheered for Captain Stella! She smiled and waved, ready for her next adventure.",
  position: 3
)
page_file = URI.parse("https://res.cloudinary.com/dyzpce9wi/image/upload/v1765276373/future_city_byjrpl.jpg").open
page3_3.image.attach(io: page_file, filename: "page3_3.jpg", content_type: "image/jpeg")


all_stories = [story1, story2, story3]
puts "Created #{Story.count} stories"

# Associate characters and universes via join tables
StoryCharacter.create!(story: story1, character: default_char1)
StoryUniverse.create!(story: story1, universe: default_univ1)

StoryCharacter.create!(story: story2, character: default_char2)
StoryUniverse.create!(story: story2, universe: default_univ2)

StoryCharacter.create!(story: story3, character: default_char3)
StoryUniverse.create!(story: story3, universe: default_univ3)


puts "Created #{StoryCharacter.count} story-character links"
puts "Created #{StoryUniverse.count} story-universe links"

# ═══════════════════════════════════════════════════════════════════════════════
# LIKES & BOOKMARKS
# ═══════════════════════════════════════════════════════════════════════════════

puts "Creating likes and bookmarks..."

# Story 1 gets likes (most popular - 7 likes)
[max_profile1, max_profile2, sophie_profile1, sophie_profile2, guest_profile, lily_profile2, lily_profile3].each do |profile|
  Like.create!(story_id: story1.id, profile_id: profile.id)
end

# Story 2 gets likes (second most popular - 6 likes)
[lily_profile1, lily_profile2, sophie_profile1, sophie_profile2, max_profile2, guest_profile].each do |profile|
  Like.create!(story_id: story2.id, profile_id: profile.id)
end

# Story 3 gets likes (5 likes)
[lily_profile1, max_profile1, max_profile2, lily_profile2, guest_profile].each do |profile|
  Like.create!(story_id: story3.id, profile_id: profile.id)
end

# Update likes_count on all stories
story1.update!(likes_count: story1.likes.count)
story2.update!(likes_count: story2.likes.count)
story3.update!(likes_count: story3.likes.count)

# Add bookmarks (favorites)
Bookmark.create!(story_id: story1.id, profile_id: max_profile1.id)
Bookmark.create!(story_id: story1.id, profile_id: guest_profile.id)
Bookmark.create!(story_id: story1.id, profile_id: sophie_profile1.id)
Bookmark.create!(story_id: story2.id, profile_id: lily_profile1.id)
Bookmark.create!(story_id: story2.id, profile_id: sophie_profile2.id)
Bookmark.create!(story_id: story3.id, profile_id: max_profile1.id)


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
puts "    - Default:        #{Character.where(is_custom: false).count}"
puts "    - Custom:         #{Character.where(is_custom: true).count}"
puts "  Universes:          #{Universe.count}"
puts "    - Default:        #{Universe.where(is_custom: false).count}"
puts "    - Custom:         #{Universe.where(is_custom: true).count}"
puts "  Stories:            #{Story.count}"
puts "    - Public:         #{Story.where(public: true).count}"
puts "    - Private:        #{Story.where(public: false).count}"
puts "    - Published:      #{Story.where(status: 'published').count}"
puts "    - Drafts:         #{Story.where(status: 'draft').count}"
puts "  Pages:              #{Page.count}"
puts "  Story-Character links: #{StoryCharacter.count}"
puts "  Story-Universe links:  #{StoryUniverse.count}"
puts "  Likes:              #{Like.count}"
puts "  Bookmarks:          #{Bookmark.count}"
puts "\nBest User Stories (by likes):"
Story.where(public: true).order(likes_count: :desc).limit(5).each_with_index do |story, i|
  puts "  #{i + 1}. #{story.title} (#{story.likes_count} likes)"
end
puts "\nLogin Credentials:"
puts "  lily@example.com / password123"
puts "  max@example.com / password123"
puts "  sophie@example.com / password123"
puts "  guest@example.com / password123"
puts "\n" + ("=" * 60)
