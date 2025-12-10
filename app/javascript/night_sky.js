// app/javascript/night_sky.js

document.addEventListener('DOMContentLoaded', function() {
  const nightSkyElements = document.querySelectorAll('.night-sky-background');

  nightSkyElements.forEach(function(skyElement) {
    generateStars(skyElement);
  });
});

// Also handle Turbo page loads (for Rails with Turbo)
document.addEventListener('turbo:load', function() {
  const nightSkyElements = document.querySelectorAll('.night-sky-background');

  nightSkyElements.forEach(function(skyElement) {
    // Clear existing stars to avoid duplicates
    skyElement.querySelectorAll('.star').forEach(star => star.remove());
    generateStars(skyElement);
  });
});

function generateStars(container) {
  const starCount = 150; // Adjust for more or fewer stars

  for (let i = 0; i < starCount; i++) {
    const star = document.createElement('div');
    star.className = 'star';

    // Random position
    star.style.left = Math.random() * 100 + '%';
    star.style.top = Math.random() * 100 + '%';

    // Random size
    const sizes = ['star-small', 'star-medium', 'star-large'];
    const sizeWeights = [0.6, 0.3, 0.1]; // More small stars, fewer large ones
    star.classList.add(getWeightedRandom(sizes, sizeWeights));

    // Random color (mostly white, some colored)
    const colors = ['', 'star-yellow', 'star-teal'];
    const colorWeights = [0.8, 0.1, 0.1];
    const color = getWeightedRandom(colors, colorWeights);
    if (color) star.classList.add(color);

    // Random animation duration (2-5 seconds)
    const duration = 2 + Math.random() * 3;
    star.style.animationDuration = duration + 's';

    // Random animation delay for staggered effect
    star.style.animationDelay = Math.random() * 2 + 's';

    container.appendChild(star);
  }
}

function getWeightedRandom(items, weights) {
  const totalWeight = weights.reduce((sum, weight) => sum + weight, 0);
  let random = Math.random() * totalWeight;

  for (let i = 0; i < items.length; i++) {
    if (random < weights[i]) {
      return items[i];
    }
    random -= weights[i];
  }

  return items[0];
}
