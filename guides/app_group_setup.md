# How to Configure App Groups in Xcode

This guide will help you enable data sharing between the main Kadigaram app and the Widget by setting up **App Groups**.

## Prerequisites
- Open the project `kadigaram/ios/kadigaram.xcodeproj` in Xcode.
- Ensure you have a valid Apple ID added to Xcode (Settings -> Accounts).

---

## Step 1: Configure Main App Target

1.  **Select the Project Root**:
    - In the left sidebar (Project Navigator), click on the top-level blue icon named **kadigaram**.

2.  **Select the Main Target**:
    - In the main central view, look at the list under **TARGETS** on the left side of the editor area.
    - Click on **kadigaram** (the first one, usually has an App icon).

3.  **Open Signing & Capabilities**:
    - Look at the tabs across the top of the main editor area (General, Signing & Capabilities, Resource Tags, etc.).
    - Click on **Signing & Capabilities**.

4.  **Add Capability**:
    - Click the **+ Capability** button (usually in the top-left corner of the tab bar, or top-right above the settings).
    - A search window will appear. Type **App Groups**.
    - Double-click on **App Groups** in the search results.

5.  **Configure the Group**:
    - A new "App Groups" section will appear in the settings list.
    - Click the **+** (plus) button at the bottom of the App Groups list.
    - A dialog "Add a new container" will appear.
    - Enter exactly: `group.com.kadigaram.app`
    - Click **OK**.
    - **Important**: Ensure the checkbox next to `group.com.kadigaram.app` is **CHECKED** (blue tick).
    - If any other groups are listed, leave them unchecked.

---

## Step 2: Configure Widget Extension Target

1.  **Select the Widget Target**:
    - Still in the **TARGETS** list on the left side of the editor.
    - Click on **KadigaramWidgetExtension**.

2.  **Open Signing & Capabilities**:
    - Ensure you are still on the **Signing & Capabilities** tab.

3.  **Add Capability**:
    - Click the **+ Capability** button again.
    - Search for and add **App Groups**.

4.  **Select the Same Group**:
    - In the "App Groups" section that appears, you should now see `group.com.kadigaram.app` in the list (Xcode usually detects it from the main app).
    - **CHECK** the box next to `group.com.kadigaram.app`.
    - **Crucial**: Both targets must have the *exact same* group identifier checked.

---

## Verification

1.  Build the project (`Cmd + B`).
2.  If you see errors about "Provisioning Profile", ensure your **Team** is selected in the "Signing" section for both targets. Xcode should automatically manage the new entitlements.

Once done, the App and Widget can share data (like Location and Settings) via this shared container!
