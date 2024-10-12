# db/seeds.rb
# rubocop:disable Layout/LineLength
Image.create([
               { title: 'Calm Ocean', url: 'https://example.com/ocean.jpg', description: 'A relaxing view of the ocean.',
                 category: 'nature', source: 'Getty' },
               { title: 'Serene Forest', url: 'https://example.com/forest.jpg', description: 'A peaceful forest scene.',
                 category: 'nature', source: 'Getty' },
               { title: 'Mountain Sunrise', url: 'https://example.com/mountain.jpg', description: 'A beautiful sunrise over the mountains.', category: 'nature', source: 'Getty' }
             ])

# Audio.create([
#   { title: 'Ocean Waves', url: 'https://example.com/ocean-waves.mp3', description: 'Relaxing ocean wave sounds.', duration: 300, audio_type: 'background music' },
#   { title: 'Morning Meditation', url: 'https://example.com/morning-meditation.mp3', description: 'A short guided meditation to start your day.', duration: 600, audio_type: 'guided session' },
#   { title: 'Rainforest Ambience', url: 'https://example.com/rainforest.mp3', description: 'Calming rainforest sounds with gentle rain.', duration: 360, audio_type: 'background music' }
# ])

# rubocop:enable Layout/LineLength
