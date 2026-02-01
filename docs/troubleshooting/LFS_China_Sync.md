# LFS Synchronization Strategy for China (No VPN)

This plan outlines how to reliably get large LFS assets in environments with restricted or throttled internet access (like China) without a local VPN.

## Proposed Strategies

### 1. Physical Object Sync (Best for Local Networks)
If you have one machine with a VPN and one without, the fastest way is to bridge them physically or via the local network.

**On the VPN-enabled Machine:**
1. Navigate to your repository.
2. Compress the LFS storage:
   ```bash
   tar -czvf lfs_objects.tar.gz .git/lfs/objects
   ```
3. Transfer `lfs_objects.tar.gz` to the China machine (USB or `scp`).

**On the China Machine (No VPN):**
1. Navigate to your repository.
2. Ensure `.git/lfs` exists: `mkdir -p .git/lfs`
3. Extract the objects:
   ```bash
   tar -xzvf lfs_objects.tar.gz -C .
   ```
4. Link the files to your workspace:
   ```bash
   git lfs checkout
   ```

### 2. Gitee Mirroring (Zero Hardware Required)
Gitee has excellent peering with GitHub and extremely fast local speeds in China.

1. **Import to Gitee:**
   - Log into [Gitee](https://gitee.com).
   - Click **+** -> **Import Repository from GitHub**.
   - Paste your GitHub URL. Gitee will pull all LFS objects using its own infrastructure.
2. **Clone from Gitee:**
   - On your China machine, clone using the Gitee URL:
     ```bash
     git clone https://gitee.com/your-username/tad-sim.git
     ```
   - LFS downloads will be at full bandwidth.

### 3. Git Configuration Tweaks
If you must use GitHub directly, try these settings to handle the 128kB/s throttle more effectively:

```bash
# Increase parallel connections
git config --global lfs.concurrenttransfers 15

# Disable SSL verification (if causing hang-ups)
git config --global http.sslVerify false

# Increase buffer for large assets
git config --global http.postBuffer 524288000
```

## Recommended Path
I recommend **Method 2 (Gitee Mirror)** if the repository can be made private/public on Gitee, or **Method 1** if you already have the files downloaded on your VPN system.
