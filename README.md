# Godot Lava Sea

This has been done as a technical exercise. The goal was to make a real-time stylized lava sea inside the Godot Engine with randomly spawning bubbles that pop after some time. The lava plane is a custom shader combining various noise textures. The bubbles are spawned inside the defined lava sea polygon using a script which respawns each bubble with randomized position, scale and lifetime. The bubble shader will be skipped when it is out of the camera's frustum to increase GPU performance.

https://github.com/user-attachments/assets/482fd817-2ddb-4f1a-97c6-43aee49f76fa

[Artstation](https://www.artstation.com/artwork/EYzwDv)

## Performance
Ensuring a good real-time performance was one of the main tasks. The project has been done and debugged on a low-spec laptop:

- **GPU:** MX350 (old Laptop GPU)
- **CPU:** Intel i7-10th generation



With the current approach, the GPU performance is almost unlimited. Instantiating really simple multimeshes for each bubble and GPU particles emitting billboard quads with a circular texture without transparency shows no problems on the GPU. The GPU is only at 50% even when instantiating 100,000 bubbles, each accompanied with GPU particles.
On the other side, CPU performance drops beginning from 35,000 instances due to each bubble having its own timer which will be randomized after its timeout and GPU particles spawning after the bubble timer runs out.

<img width="1439" height="1032" alt="MaximumBubbleCount" src="https://github.com/user-attachments/assets/ecdad2ca-6fb6-482c-a82a-a6738d23ff77" />

## Two approaches to rework the bubble spawning could be
- batching the bubbles into chunks, each chunk has one timer and respawns all of them at the same time. These batches could be a variable total count to have almost the same CPU overhead no matter the bubble count. Alternatively, it could also be based on a variable chunk size which would adapt to the bubble count but also increase the CPU overhead on higher bubble counts.
- completely shader based bubbles, each bubble will be randomly spawned according to multiple noise textures dictating position, scale and lifetime. This would be the more complex but maybe a more efficient approach.

## Other improvements
- Disable all bubbles when the player is not in the area
- slowly start instantiating bubbles at the start because in the current approach there is a huge lag at the start because all bubble timers are started at once which may be unimportant once the bubble spawning is improved.
