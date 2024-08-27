import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import os

# Set up the figure and axis
fig, ax = plt.subplots()
ax.set_facecolor('black')
ax.set_xlim(0, 10)
ax.set_ylim(0, 10)
ax.set_aspect('equal')
plt.axis('off')

# Initialize the line object
line, = ax.plot([], [], 'w-', lw=2)

# Initialize the animation
def init():
    line.set_data([], [])
    return line,

# Function to create geometric pattern (e.g., rotating square)
def update(frame):
    # Clear the current line data
    line.set_data([], [])
    
    # Define the square
    length = 2
    center = [5, 5]
    angle = np.deg2rad(frame)
    
    # Calculate the square's corner positions
    square = np.array([
        [center[0] - length / 2, center[1] - length / 2],
        [center[0] + length / 2, center[1] - length / 2],
        [center[0] + length / 2, center[1] + length / 2],
        [center[0] - length / 2, center[1] + length / 2],
        [center[0] - length / 2, center[1] - length / 2]
    ])
    
    # Rotate the square
    rotation_matrix = np.array([
        [np.cos(angle), -np.sin(angle)],
        [np.sin(angle), np.cos(angle)]
    ])
    rotated_square = np.dot(square - center, rotation_matrix) + center
    
    # Update line data
    line.set_data(rotated_square[:, 0], rotated_square[:, 1])
    return line,

# Create the animation
ani = animation.FuncAnimation(fig, update, frames=np.arange(0, 360, 5), init_func=init, blit=True)

# Save the animation as mp4 in the same directory as the script
output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'geometric_pattern.mp4')
ani.save(output_path, writer='ffmpeg', fps=30)
