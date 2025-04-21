# 📜 Scripts I made for my DayZ Server 📜

<br>

These are custom scripts I created for my DayZ Server: `start.cmd` and `backup_7z.ps1`.

+ **start.cmd:** _This batch script is used to start the server, launch its mods, and run the backup script._
+ **backup_7z.ps1:** _This PowerShell script is responsible for creating a full backup of the server. It compresses all files and directories into a ZIP file placed inside a folder named `DayZServer_dd-MM-yyyy_-_00h-00m-00s`_

<br>

## 🔗 **_Dependencies_** 🔗
>[!IMPORTANT]
>**7-Zip** must be installed for the backup script to work. Download it from **[here](https://www.7-zip.org/download.html)**.
><br>_<sub>I used the **.msi** installer for 64-bit, in case you're interested.</sub>_

>[!WARNING]
>It is recommended to have **PowerShell 7** installed for compatibility with **[backup_7z.ps1](https://github.com/JotaQC/DayZ-Server-scripts/blob/main/backup_7z.ps1)**. Download it from **[here](https://github.com/PowerShell/PowerShell/releases)**.
><br>_<sub>For stability, always use the **Latest** version, **NOT** the **Pre-release** — that’s what I prefer.</sub>_

<br>

## 🚀 **_Usage_** 🚀
>[!NOTE]
>To run the server and trigger automatic backups, simply run with double click `start.cmd`.
><br>Make sure you've configured the paths and mods inside `start.cmd` and `backup_7z.ps1` accordingly.
