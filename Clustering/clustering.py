import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from sklearn.cluster import KMeans
from matplotlib.animation import FFMpegWriter

# Generate dummy data
np.random.seed(42)
num_people = 15
interests = ['Bouldern', 'Kino', 'Museum', 'Joggen', 'Kochen', 'Wandern', 'Klavier']
locations = ['Freimann', 'Marienplatz', 'Fürstenried', 'Fürstenried West', 'Giesing']

people = []
for _ in range(num_people):
    interest = np.random.choice(interests)
    location = np.random.choice(locations)
    people.append({'interest': interest, 'location': location})

# Map interests and locations to continuous values for 2D space
interest_map = {name: i for i, name in enumerate(interests)}
location_map = {name: i for i, name in enumerate(locations)}

X = np.array([[interest_map[p['interest']] + np.random.rand(),
               location_map[p['location']] + np.random.rand()] for p in people])

# Apply KMeans clustering
num_clusters = num_people // 3
kmeans = KMeans(n_clusters=num_clusters, random_state=42, n_init=10)
clusters = kmeans.fit_predict(X)

# Adjust points to visually group clusters closer together
cluster_centers = kmeans.cluster_centers_
grouped_X = X.copy()

for i, center in enumerate(cluster_centers):
    cluster_indices = np.where(clusters == i)[0]
    offset = np.random.rand(len(cluster_indices), 2) * 0.5 - 0.25  # Add randomness within the group
    grouped_X[cluster_indices] = center + offset

# Create the figure and axis
fig, ax = plt.subplots(figsize=(10, 6))
ax.set_facecolor("#f0f0f0")  # Soft gray background
scatter = ax.scatter(X[:, 0], X[:, 1], c='gray', s=200, edgecolor='black', linewidth=0.5)

# Initialize text annotations
texts = []
for i, person in enumerate(people):
    text = ax.text(X[i, 0] + 0.1, X[i, 1] + 0.1,  # Start with slight offset
                   f"({person['interest']}, {person['location']})",
                   fontsize=10, fontweight='bold', ha='center', va='center')
    texts.append(text)

ax.set_title("Transitioning Clusters", fontsize=14, fontweight='bold')
ax.set_xlabel("Interests", fontsize=12, fontweight='bold')
ax.set_ylabel("Locations", fontsize=12, fontweight='bold')
plt.tight_layout()

# Animation function
def update(frame):
    t = frame / 50  # Normalize frame to [0, 1]
    interpolated_X = (1 - t) * X + t * grouped_X
    scatter.set_offsets(interpolated_X)

    # Update text positions with offset to avoid overlap
    for i, text in enumerate(texts):
        # Calculate offset based on distance to the final position
        offset_scale = 0.1 + (1 - t) * 0.5  # Larger offset earlier, smaller offset later
        text.set_position((interpolated_X[i, 0] + offset_scale,
                           interpolated_X[i, 1] + offset_scale))

    if t == 1:
        scatter.set_color([plt.cm.tab10(c) for c in clusters])  # Color by clusters

# Create animation
ani = FuncAnimation(fig, update, frames=51, interval=50, repeat=False)

# Save the animation as an MP4 file using ffmpeg
writer = FFMpegWriter(fps=20, metadata=dict(artist='Eliah'), bitrate=1800)
ani.save("transition_animation.mp4", writer=writer, dpi=300)

# Show the animation
plt.show()









