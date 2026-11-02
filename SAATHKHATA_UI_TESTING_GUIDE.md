# SaathKhata App — Complete Testing Guide

**A plain-English walkthrough of every screen and button in the app, for testers who don't code.**

---

## How to Use This Guide

SaathKhata is an app that connects three kinds of people:

1. **Vendor** — a shop owner (dairy, kirana store, salon, etc.) who tracks what customers owe them ("khata"), manages staff, takes bookings/orders, and runs membership plans.
2. **Customer** — someone who buys from a vendor and keeps track of their bill/dues through the app.
3. **Staff / Delivery Person** — an employee of the vendor (e.g. a delivery boy) who logs in separately, records deliveries and payments on the vendor's behalf, but has fewer permissions than the vendor.

This guide is split into three matching sections. Each screen is described as:
- **What you see** — what's on screen when it opens
- **What you can tap** — every button/action, written as "Tap X to do Y"
- **What happens** — the result, success message, or error you should expect
- **Watch out for** — edge cases worth trying (empty states, bad input, spotty internet, etc.)

At the end of each role's section is a **"Things to Double Check"** list — specific spots where the behavior seemed unusual, incomplete, or worth a second look. These aren't necessarily bugs, but a tester should try them on purpose and confirm they work as intended.

There's also a final **Cross-Cutting Issues** section that lists patterns that showed up in more than one place across the whole app (e.g., certain buttons silently doing nothing when a field is left blank).

**Tip for testers:** where this guide says "silently does nothing" or "no error shown," that is the single most valuable thing to go test — a non-technical user will experience these as "this app is broken" even though nothing crashed.

---

# PART 1 — VENDOR (Shop Owner)

The vendor's app has a bottom navigation bar with six tabs: **Home, Staff, Booking, Schedule, Reports, Settings.** Several screens (Customer Detail, Outstanding List, Collected Today, Shared Ledger, etc.) are opened by tapping into these tabs — they don't have their own nav bar icon.

## 1.1 Vendor Home / Dashboard

**What you see:** A greeting at the top, a bell icon (red badge if you have unread notifications), a search bar, a "Collection Summary" with two big cards — **Outstanding** (money owed to you) and **Collected Today** — a "Quick Actions" row (Remind All, Add New, Daily Charge, Orders), any pending customer connection requests, a "Recent Customers" list, and — only if you also buy from another vendor yourself — a "My Vendors" section at the bottom.

**What you can tap:**
- **Bell icon** → opens Notifications.
- **"Outstanding" card** → opens the full list of every customer who owes you money.
- **"Collected Today" card** → opens the full list of today's payments.
- **"Remind All"** → sends a payment reminder to every customer who owes you money. A green message tells you how many people were reminded (or says "No customers with outstanding balance" if nobody owes you anything). There is **no "are you sure?" pop-up** before this sends — one tap messages everyone.
- **"Add New"** → opens a small form to add a new customer.
- **"Daily Charge"** → opens the Bulk Charge screen (charge many customers for the same item at once).
- **"Orders"** → opens your Orders screen.
- **"View All"** (next to Recent Customers) → opens the full customer list.
- **Any customer's name in the list** → opens that customer's full details.
- **Pull down from the top** → refreshes everything on screen.

**Watch out for:**
- If the dashboard fails to load (e.g., no internet), there's **no "Retry" button** on this particular screen — you'd have to leave and come back.
- The pending-connection-requests section doesn't refresh when you pull down — it only loads once, so it can look outdated even after you've handled a request elsewhere.

### Add Customer (the form that opens from "+ Add New")

**What you see:** A small pop-up sheet with two boxes — "Phone or Email" and "Nickname" (optional) — and an "Add Customer" button.

**What you can tap:** Fill in the phone/email, tap "Add Customer."

**What happens:** If it works, the sheet closes and a green message confirms the request was sent. If something's wrong on the server side, the sheet stays open and shows a red message with the reason. **If you leave the phone/email box empty and tap the button, nothing happens at all — no message, no error.** This isn't a crash; the button is just designed to quietly ignore an empty field.

**Watch out for:** Remember, this only *sends a request* — the other person still has to accept it before you're actually connected.

---

## 1.2 All Customers Screen

**What you see:** Every customer linked to you — name, a small membership badge if they have one, phone number or nickname, and their current balance in red.

**What you can tap:** Tap a name to open their details. Pull down to refresh. Tap "Retry" if the list fails to load.

**Watch out for:** If you have zero customers, you'll see an empty message instead of a list.

---

## 1.3 Customer Detail Screen

This is where you manage one specific customer. It has four tabs across the top: **History, Dues, Delivery, Info.**

**What you see (top of screen):** The customer's name/phone/nickname, a membership badge if applicable, and a shopping-cart icon (used to place a new order on their behalf).

### History tab
Shows their running balance, a membership banner if they have a plan, filter options, the full list of every transaction, and two buttons at the bottom:
- **"Record Payment" (green)** → opens a form: amount, description, date (can't pick a future date, and can't go back more than 1 year), an optional quantity, and an optional photo (camera or gallery) as proof. The submit button only turns on once you've entered an amount and a description.
- **"Give Credit" (red)** → opens a form for adding one or more purchased items/services in a single entry (e.g., "2kg rice + 1L oil" as one bill).

**Watch out for:** Neither button asks "are you sure?" before submitting — tapping submit records the entry immediately.

### Dues tab
Same balance info, but filtered to only show unsettled amounts, plus a **"View Monthly Statement"** button for a month-by-month breakdown.

### Delivery tab
Shows a banner explaining delivered orders, and the same Record Payment/Give Credit buttons, filtered to delivery-type entries only.

**Watch out for:** This tab shows up for every single vendor account, even ones that don't do deliveries (e.g. a salon). This looks like it was meant to only appear for certain business types (like dairy or tiffin services) but currently always shows — worth flagging to the developers if it doesn't make sense for your business type.

### Info tab
Shows the customer's basic details (name, mobile, nickname, how long you've been linked), a "Default Delivery" section (their usual order — tap Edit/Set to change it), and their membership info if they have a plan.

**What you can tap:**
- **Shopping-cart icon (top of screen)** → opens a full-screen form to place an order for this customer (see "Place Order" below).
- **Edit/Set Default Delivery** → opens a small form: product name, default quantity, unit, price per unit. Save. This is mainly used to pre-fill Quick Delivery for your delivery staff.

**Watch out for:** Typing letters into the quantity/price boxes is silently ignored — no error message tells you why it didn't save. Also, saving this form with everything left blank is allowed, and will erase any previously saved defaults with no warning.

### Place Order for Customer
**What you see:** A form starting with one blank item row — item name (required), quantity, unit, price, and a live-updating subtotal. An "Add Item" button lets you add more rows. There's an optional note field, and a running total at the bottom.

**What you can tap:** Add or remove item rows (you can't remove the last one). Fill in details — subtotal and total update as you type. Tap "Place Order" once done.

**What happens:** It checks that every item has a name filled in. If you leave quantity or price blank, it's **silently treated as 1 (for quantity) or 0 (for price)** — no warning is shown, so double-check your numbers before submitting. On success, you'll see a confirmation and the screen closes on its own.

---

## 1.4 Outstanding List (everyone who owes you money)

**What you see:** A title showing how many customers owe you money, and a list (name, phone, amount due).

**What you can tap:** Tap any row to jump straight to that customer's transaction history. Scroll to the bottom to load more (loads 20 at a time). Pull down to refresh from the top.

**Watch out for:** If you have zero customers with dues, you'll see a friendly "All customers settled up" message. **If the list fails to load more while you're scrolling (e.g. you lose signal halfway down), it just quietly stops loading more — no error message appears.** Test this by scrolling through a long list with unstable internet.

---

## 1.5 Collected Today (today's payments)

**What you see:** How many payments you've received today, and a list (customer, amount in green, time it was recorded).

**What you can tap:** Same as Outstanding List — tap a row for details, scroll for more, pull down to refresh.

**Watch out for:** Same silent-stop issue as Outstanding List if scrolling fails partway. Also, if the time can't be read properly, it'll just show blank instead of an error — worth testing entries recorded right around midnight.

---

## 1.6 Staff & Labour Management

### Staff List (the "Staff" tab)

**What you see:** A summary bar ("Present today: 3/5", total unpaid salary), then a card for each staff member (name, role, salary rate, today's attendance badge, unpaid salary, any advance they've taken). A floating "Add Staff" button.

**What you can tap:**
- **"Add Staff"** → a form: Full Name, Phone Number, Role (pick from a list), Salary Type (Daily or Monthly), and the salary amount.
  - **If you leave the name blank or enter ₹0 or less for salary, nothing happens when you tap Add — no error message appears.**
  - If the phone number isn't a valid 10-digit Indian mobile number (must start with 6-9), you'll see a red "Invalid phone" message and the form stays open.
  - If everything's valid, **the form closes right away**, and the actual saving happens in the background — so there's a brief moment where the staff member isn't in the list yet even though the form has closed.
- **Tap a staff card** → opens their full details.
- **Tap the "Attendance" pill on a card** → a quick pop-up menu to mark them Present/Absent/Half Day for today, without opening their full profile.

**Watch out for:** If adding a staff member fails after the form has already closed (e.g., duplicate phone number, no internet), **there's no pop-up message at all — instead, your entire staff list gets replaced with a plain "Failed to add staff" error screen**, which can be alarming since it looks like you've lost all your staff data (you haven't — it's just a display glitch). Pulling down to refresh also shows **no error message at all** if it fails.

### Staff Detail Screen

**What you see:** The staff member's name at the top with a quick "Pay ₹" button (only shown if they're owed money) and a delete icon. Below: their profile, salary summary, an "App Access" toggle, a monthly attendance calendar, "Add Advance"/"Pay" buttons, and (for monthly-salary staff only) a "Record this month's salary" button, plus their payment history.

**What you can tap:**
- **"Pay ₹" button** → a form pre-filled with the amount they're owed, plus an optional field for a UPI transaction ID. Tapping "Payment Confirmed" **immediately marks the salary as paid**, then takes you to a UPI screen — **this happens regardless of whether you actually completed a UPI transfer**. If you back out of that UPI screen, the salary still shows as paid. This is worth testing carefully, since it's easy to assume the payment only counts once you finish the UPI step — it doesn't.
- **Delete (trash) icon** → asks "Are you sure?" before removing the staff member. **This works even if they're still owed salary or have an outstanding advance — no warning about the money involved is shown.**
- **Calendar arrows** → move to the previous/next month (can't go before they joined, or past today).
- **Month/year label** → opens a picker to jump straight to any month/year.
- **Tap any date on the calendar** → mark Present/Half Day/Absent for that day (you can't mark future dates).
- **"Add Advance"** → a form with Amount and an optional Note. Entering ₹0 or less silently does nothing when you tap submit.
- **"Record this month's salary"** (monthly staff only) → asks you to confirm the amount, then adds it to their unpaid balance.
- **"App Access" toggle** → turns the staff member's app login on or off.
  - **This has no "are you sure?" step**, even though switching it off could immediately log them out of an active session. Compare this to Delete Staff, which does ask for confirmation — worth testing that this asymmetry is intentional.
  - If it fails, the switch flips back and shows an error message (which may show raw technical text rather than a friendly explanation).

**Watch out for:**
- **There is currently no way to edit a staff member's name, phone, role, or salary rate after creating them** — you can only add or delete, not correct a typo.
- If marking attendance or adding an advance fails, **no error message is shown at all** — it fails completely silently, unlike Pay Salary and Delete, which do show errors.
- The payment history at the bottom shows "Could not load payment history" with **no Retry button** if it fails to load.

---

## 1.7 Scheduling, Bookings, and Subscriptions

There are **two separate systems** in this app that both deal with dates and times, but work independently:

1. **Schedule** (the "Schedule" tab) — for recurring subscriptions, like a daily milk delivery.
2. **Booking** (the "Booking" tab) — for one-time appointments, like a salon slot.

### Scheduled Services ("Schedule" tab → Services)

**What you see:** A list of your recurring services (e.g. "Milk – Daily") as cards, each showing the name, schedule, item/price summary, and how many customers are subscribed. A floating "+ New Service" button.

**What you can tap:**
- **"+ New Service"** → a form: Service Name (required), optional Description, a toggle for how often it repeats (every day, or specific weekdays), and a list of items with prices. Tap "Create Service" once filled in.
  - It checks that the name is filled in, at least one day is picked, and every item has a valid (non-negative) price.
  - **If saving fails on the server side, absolutely no error message is shown — the form just sits there, looking stuck.** This is one of the more important things to test: fill out a valid form, then try it with the internet turned off, and see that nothing tells you it failed.
- **Tap a service card** → opens its full details.

**Service Detail screen:**
- **⋮ menu (top-right) → "Deactivate"** → asks "are you sure?" before stopping all future deliveries for that service. **Once deactivated, there is currently no button anywhere to turn it back on** — the option to reactivate simply isn't in the app yet.
- **"Add Customer" (subscriber)** → pick a customer, set how much of each item they get, and a start date. Same silent-failure issue as creating a service — if it fails, nothing tells you.
- **⋮ menu on an individual subscriber → Pause / Resume / Remove.** Pause and Resume don't ask for confirmation (reasonable, since they're easy to undo), but **"Remove" also doesn't ask for confirmation**, even though it's permanent — worth double-checking this is intentional, since it's inconsistent with Deactivate (which does ask).

### Today's Deliveries ("Schedule" tab → Deliveries)

**What you see:** A filter bar (status, date, search by customer/service, distance), then a list of today's scheduled deliveries as cards.

**What you can tap:**
- **"Call" chip on a card** → opens your phone's dialer with the customer's number already filled in.
- **Address chip** → opens Google Maps to that customer's location.
- **"Skip" button** (only appears if the delivery is due today and not yet done) → asks "are you sure?" then marks it skipped.
- **"Delivered" button** → opens the Confirm Delivery screen (see below).
- **Tap anywhere else on the card** → opens the full Delivery Detail screen.

**Confirm Delivery screen:** Shows read-only details (date, customer, who's delivering, items, total). You must **take or choose a photo before you're allowed to tap "Confirm Delivery"** — there's no way around this requirement, so make sure you have a working camera or a photo ready when testing this.

**Watch out for a specific inconsistency:** if you tap "Skip" from the delivery list, you stay on the list after confirming. But if you tap "Skip" from the Delivery Detail screen instead, it closes **two** screens at once and dumps you further back than expected. Try skipping a delivery both ways and compare — this looks like an unintentional inconsistency.

### Appointments ("Booking" tab)

**What you see:** Two view options — "Bookings" (in time order) and "By Slot" (grouped by time slot) — plus a horizontal strip of days you can tap through (2 days in the past to 11 days ahead).

**What you can tap:** Tap a day to load its bookings. Tap a booking that's still pending or confirmed to get action options: **Confirm**, **Mark Complete**, or **Cancel** (Cancel has an extra "are you sure?" step; the others don't).

**Watch out for:** In "By Slot" view, tapping the header of a time slot and tapping its small arrow icon do two *different* things (one opens full details, the other just expands the row in place) even though they're right next to each other — easy to tap the wrong one by accident, worth testing on a small phone screen.

### Manage Schedule (setting your available appointment times)

Two modes: **Weekly Template** (your normal weekly hours) and **Calendar** (special one-off changes to a specific date).

**Weekly Template:** Pick a day tab, see your time slots for that day, and tap "Add Slot" to create a new one (start time, end time, how many people it can hold). Existing slots can be edited or deleted (delete asks for confirmation). You can select multiple slots and merge them together.

**Important thing to know:** on this screen, every change you make (adding, editing, deleting, merging slots) requires you to tap a **"Save"** button before it actually takes effect — **except for the "Slots Full" toggle, which saves the moment you tap it**, with no separate Save step. This is easy to mistake for a bug, but it's how the screen is built — worth explicitly testing so you're not surprised.

**Calendar mode:** Tap any date on the month view to see or change that specific day's hours (separate from your usual weekly schedule) — including marking a day fully closed, undoing a special change to go back to your normal schedule, or copying that day's hours forward to future weeks/months. If copying to multiple dates and some fail, you'll get a count of how many worked and how many didn't, **but not which specific dates failed** — so if 3 out of 10 fail, you'll need to check each date yourself to find out which three.

---

## 1.8 Orders and Bulk Charge

### Vendor Orders

**What you see:** Tabs for All / Pending / Confirmed / Delivered orders. Each order card shows the customer, status, first few items, and total.

**What you can tap:** Tap a tab to filter. Tap a card to see full details. On a pending order, **Confirm** and **Reject** buttons work immediately with **no "are you sure?" step** — one tap is final.

**Watch out for:** If confirming or rejecting an order fails (e.g., no internet), on this particular screen your **entire order list gets replaced with a plain error message** — it can look like you've lost all your orders, though you haven't; it's just how errors are displayed here.

### Order Detail Screen

Same Confirm/Reject actions as above, but this screen **does show a proper error message if something fails** (unlike the list screen). For a confirmed order, tapping "Mark as Delivered" opens a form requiring an optional note and a photo of the delivery.

**Watch out for:** After you take/choose the photo and tap to confirm delivery, **the screen may close as soon as the photo finishes uploading — even before it's confirmed that the delivery status itself was successfully updated.** If your connection drops at exactly the wrong moment, you might think a delivery was marked done when it actually wasn't. Worth testing with a deliberately unstable connection.

### Bulk Charge ("Daily Charge")

**What you see:** A "+" button to create a new billable product, a row of product/service chips you can pick from, and — once you've picked one — a list of your customers with +/- buttons to set how many units to charge each of them, live-updating subtotals, and a "Charge All" button at the bottom.

**What you can tap:**
- **"+"** → a form: product Name, Unit, Price. **If you leave the name blank or set price to ₹0 or less, tapping Save does nothing — no error message.**
- **Long-press a product chip** → Edit or Delete it (Delete asks for confirmation).
- **+/- on each customer row** → set the quantity to charge them.
- **"Charge All"** → only enabled once at least one customer has a quantity above zero. Submits everyone at once in a single action.

**What happens:** You'll get a success message showing how many people were charged. **Important:** if *some* people were charged successfully but others failed, the message is still shown in the same green "success" styling as a full success — **it only turns red if absolutely everyone failed.** This means it's easy to miss that a few customers weren't actually charged. Read the message text carefully, not just its color, when testing this.

**Watch out for:** Switching to a different product while you still have quantities entered for the current one **silently clears everything you'd entered**, with no warning.

---

## 1.9 Membership Program

### Membership Plans (Settings → Memberships → Membership Plans)

**What you see:** Cards for each plan (name, price, duration, list of benefits with usage limits like "×10", how many members are on it). A floating "New Plan" button.

**What you can tap:**
- **"New Plan" / edit pencil** → a form: Name, Duration (in days), Price, a repeatable list of benefits (each with a label and an optional usage limit — leave the limit blank for unlimited), and an optional advance-payment amount.
  - **If you fill in a usage limit for a benefit but forget to type its label, that whole benefit row is silently dropped when you save** — worth double-checking your benefit list carefully after saving.
- **Deactivate / Activate** → takes effect **immediately, with no confirmation step.**
- **Delete (trash icon)** → does ask "are you sure?" first.

**Watch out for:** No explanation is given anywhere about what happens to a customer's existing membership if you delete or edit the plan they're on — worth testing directly to see the actual result.

### Members Dashboard (Settings → Memberships → Members)

**What you see:** Stat tiles (active members, monthly revenue, how many are expiring soon), filter chips by plan, and a card per member (name, plan, expiry date, usage like "6/10", and a warning if their plan expires within 7 days).

**What you can tap:** Tap a plan chip to filter. Tap a member card to jump to their full customer details.

**Watch out for:** There's no explanation anywhere of how the "monthly revenue" number is actually calculated — if that number looks off during testing, it's worth asking the developers what formula it uses.

### Membership Requests (Settings → Memberships → Membership Requests)

**What you see:** A card per customer who's applied for a membership plan — their name, when they applied, which plan they want, and any message they included. **Approve** and **Decline** buttons.

**What you can tap:** Approve or Decline. **When it works, the card just quietly disappears — there's no success message at all**, only failures show a message. **Decline also has no "are you sure?" step**, so a single accidental tap permanently rejects someone with no way to undo it.

**Watch out for:** The little number badge that shows how many pending requests you have (visible from the Settings menu) **does not update immediately after you approve or decline** — it may show a stale count until you leave and re-enter the screen.

### Membership Banner (inside a customer's own page)

**What you see:** Inside a specific customer's History tab — their plan name, days remaining, an Enroll/Change button, and if their plan includes limited-use benefits (like "5 free washes"), a usage counter for each with a "Use" button and a small red minus-button (for you to manually correct an accidental "Use" tap).

**What you can tap:** "Enroll/Change" opens a list of your plans — **tapping a different plan switches the customer to it immediately, with no confirmation step**, even though this could affect their billing. "Use" marks one unit of a benefit as used. The small minus-button reduces the usage count by one, in case you tapped "Use" by mistake.

**Watch out for:** Since switching plans has no confirmation, this is a good spot to test an accidental tap doesn't cause unwanted billing changes.

---

## 1.10 Shared Ledger (the core "khata book" screen)

This is the heart of the app — where every payment and charge for one specific customer lives.

**What you see:** The customer's name at the top with a small dot showing whether you're "live" connected (green, updates instantly) or offline (grey, "updates paused"). A balance card showing who owes whom, with a "Statement" button to export a PDF. Filter options (All/Pending/Confirmed/Disputed). The full transaction list. At the bottom: **"Record Payment"** and **"Give Credit"** buttons, plus a floating microphone button for voice entries.

**What you can tap:**
- **Deliveries icon** → shows only delivery-related entries.
- **Orders icon** → shows this customer's orders.
- **Monthly Statement icon** → a month-by-month summary of billed vs. paid amounts.
- **Remove-link icon (red, broken chain)** → asks "are you sure?" before disconnecting from this customer entirely.
- **Info icon** → explains what "Confirmed," "Pending," and "Disputed" mean.
- **"Statement" button** → creates and shares a PDF (only available if there's at least one transaction).
- **"Record Payment"** → log a single payment (amount, description, optional date/photo).
- **"Give Credit"** → log one or more items purchased in a single bill.
- **Tap any transaction** → see its full details (amount, date, description, photo if any). If it's a multi-item bill, tapping it expands the item list right there instead of opening a new screen.
- **Confirm / Dispute** — these buttons only show up on entries that *you* did not personally create (they're for approving or flagging something the other person entered). Confirm asks "confirm this ₹X entry?" Dispute requires you to type a reason.

**Important things to test carefully — these were found to fail silently:**
- **Recording a payment, confirming an entry, and disputing an entry all currently show no error message if something goes wrong** (e.g., no internet). Try each of these three actions with your phone in airplane mode and see that nothing visibly tells you it failed — this is one of the most important things in the whole app to verify with the development team.
- The "Dispute" reason box doesn't visually grey out the submit button when it's empty — tapping submit with no reason typed just does nothing, which can feel like a broken button.
- **A "Payment Verification" screen exists in the app's code but is not reachable from anywhere in the actual app.** The real way to verify a customer's claimed payment is the Confirm/Dispute buttons described above, not a separate screen — you don't need to look for a dedicated "verify payment" button elsewhere, it doesn't exist in the visible app.

---

## 1.11 Settings & Account

**What you see:** Your profile card at the top (name, email, business type), then sections for Account Information, Account Settings, Memberships, Legal Info, and Logout.

**What you can tap:**
- **Edit Profile** → update your details.
- **Change Password** → change your login password.
- **Delete Account (red)** → asks "are you sure?" with a clear warning that this is permanent.
- **App Language** → pick from 12 languages.
- **My UPI IDs** → manage the UPI payment addresses customers can pay you at.
- **Help & Support** → **currently does nothing at all when tapped** — this is a dead button with no screen behind it. Don't spend time looking for a support screen; it isn't there yet.
- **Membership Plans / Members / Membership Requests** → covered in section 1.9.
- **Terms & Conditions / Privacy Policy** → shows the legal text.
- **Logout** → asks "are you sure?" first.

### My UPI IDs

**What you see:** A list of your UPI payment addresses, each with a star (tap to mark it as your main one) and a delete icon. A counter shows how many you have out of a maximum of 5.

**What you can tap:** Tap a star to set that ID as primary. Tap the trash icon to delete an ID — **this deletes it immediately with no "are you sure?" step**, so be careful during testing not to accidentally remove a real UPI ID. Tap "Add UPI ID" to add a new one (must be in the format `name@bank`). Tap "Save" (top of screen) to actually send your changes to the server.

**Watch out for:** If you make changes (like deleting or reordering) and then leave the screen **without tapping Save, all of it is silently thrown away** — there's no "you have unsaved changes" warning.

### Scan Bill (important note)

This feature (scanning a paper bill with your camera to auto-create a khata entry) **exists in the app's code but currently cannot be opened from anywhere in the normal app** — there's no button or menu that leads to it. If you do somehow reach it (e.g., a developer opens it directly for testing), be aware that right now: the camera view doesn't actually take a real photo, and the form that follows is pre-filled with fake placeholder data regardless of what you "photographed" — tapping "Save to Khata" does not save anything real. **Don't test this feature through normal exploration — it's not accessible, and isn't functional yet if you do find a way in.**

---

## 1.12 Voice Entry (speak instead of type)

Available from the microphone button on the Shared Ledger screen.

**How it works:**
1. **Listening** — speak your entry (e.g. "add 200 rupees for milk"); tap stop when done, or it stops automatically once you finish speaking.
2. **Thinking** — a brief pause while your words are turned into a structured entry. **There is no way to cancel at this step** — if this takes too long or hangs, you're stuck waiting (the pop-up can't be dismissed by tapping outside it either).
3. **Review** — check the amount/description/quantity it understood, with the option to switch between "Give Credit" and "Record Payment." Everything is editable before you confirm.
4. **Confirm Entry** → saves it.

**Watch out for:** If the amount ends up as ₹0 or blank and you tap "Confirm Entry," **nothing happens — no error, no shake, nothing** — it can look like the button is broken. Also worth testing: no internet during the "Thinking" step, since it needs a connection to understand your speech.

---

## Vendor: Things to Double Check

1. No "are you sure?" step before "Remind All" messages every customer who owes you money.
2. Dashboard shows no Retry button if it fails to load.
3. Delivery tab always shows on Customer Detail, even for shop types that may not need it.
4. Typing letters into numeric fields (Customer Defaults) is silently ignored with no error.
5. Add Staff, Add Advance, Mark Attendance, and Create Service/Subscribe **all silently do nothing on invalid input or network failure** — test each of these specifically with blank fields and with the internet off.
6. Marking a staff salary "paid" happens instantly and is **not tied to whether a real UPI payment actually completed** afterward.
7. Revoking a staff member's app access has no confirmation step, unlike deleting a staff member (which does).
8. There is no way to edit a staff member's or a service's details after creating them — only delete and recreate.
9. Outstanding List and Collected Today both silently stop loading more results if your internet drops mid-scroll.
10. Skipping a delivery behaves differently (closes one screen vs. two) depending on whether you do it from the list or from the detail screen.
11. The "Slots Full" toggle in Manage Schedule saves instantly, while every other change on that screen needs a separate "Save" tap.
12. Bulk Charge's success message stays green even when only *some* customers were actually charged — read the text, not just the color.
13. Deactivating or Activating a membership plan has no confirmation step; deleting one does.
14. Declining a membership request is permanent with no confirmation and no undo.
15. Switching a customer's membership plan has no confirmation step, despite affecting their billing.
16. Recording a payment, confirming an entry, and disputing an entry on the core ledger screen **all fail silently with no error message** — this is the single most important thing in this guide to verify with your team.
17. "Help & Support" in Settings does nothing when tapped.
18. Deleting a UPI ID has no confirmation, and unsaved UPI changes are silently discarded if you navigate away.
19. The Scan Bill feature is unreachable from the normal app and non-functional if reached directly.

---

# PART 2 — CUSTOMER

The customer's app has a bottom navigation bar with five tabs: **Home, My Khatas, Bookings, Schedule, Profile.**

## 2.1 Getting Started — Sign Up and Login

### Splash Screen
The logo shows for about 2 seconds while the app checks if you're logged in. No action needed — it takes you automatically to the right next screen.

### Choose Your Language
A grid of 12 languages. Tap one to select it — the whole app switches to that language right away. Tap "Continue."

**Watch out for:** Two of the listed languages (Bhojpuri and Maithili) currently fall back to Hindi text in some places — a small quirk in how those languages were set up.

### Onboarding Slides
Three short intro slides about what the app does. Tap "Next" through them, "Get Started" on the last one, or "Skip" anytime.

### Choose Your Role
Two cards: "Vendor" and "Customer." Tap the one that applies to you, then "Continue."

**Watch out for:** If you accidentally tap *both* cards (the app lets you select both, and shows a note about "dual roles"), it will quietly proceed as if you'd chosen **Vendor only** — your customer selection is ignored in that case. Make sure to tap only "Customer."

### Enter Phone Number
Type your 10-digit mobile number and tap "Send OTP." A link at the bottom lets you use email/password instead if you prefer.

### Enter OTP
Type the 6-digit code sent to your phone (during testing, this is usually a fixed test code — check with whoever set up your test account). Tap "Verify." Tap "Resend OTP" if you didn't get it.

### Complete Your Profile (first-time users)
Add a profile photo (optional), your name (required), optional email, and — **importantly — pick your role again here** (Customer or Vendor). This defaults to "Vendor," so if you came from the phone-number sign-up path, **make sure you tap "Customer" here even if you already chose it on an earlier screen** — this screen doesn't remember your earlier choice. Also set your delivery address by tapping the location picker.

**Watch out for:** This is an easy step to miss — a tester who doesn't notice the role toggle here could accidentally end up signed up as a vendor.

### Location Picker (used during sign-up and later for your address)
Drag the map or search by typing an address; tap the "my location" button to use your phone's GPS. Tap "Confirm Location" once you're happy with the pin.

**Watch out for:** If you deny location permission or your GPS fails, the app quietly falls back to a default location **without telling you** — it's worth checking that a sensible address gets set, not a strange or blank one, when you deny permission on purpose during testing.

---

## 2.2 Customer Dashboard (Home tab)

**What you see:** A notification bell, a search bar to find vendors, any pending connection requests from vendors, a "Total Due" card, an "Upcoming Appointments" card, a "My Orders" button, and a list of the vendors you're connected to (each showing what you owe them).

**What you can tap:**
- **Bell icon** → Notifications.
- **Search bar** → search/browse vendors.
- **A pending request banner** → opens the request so you can Accept or Decline it.
- **"Pay All Dues"** (shown if you owe money to any vendor) → walks you through each vendor one at a time, letting you pay via UPI or skip, ending with a summary of what was paid vs. skipped.
- **"My Orders"** → your order history.
- **A vendor's name in the list** → opens your full transaction history ("khata") with them.
- **"Book" / "Order" quick buttons on a vendor tile** → jump straight to booking an appointment or placing an order with that vendor.
- **Floating "ADD VENDOR" button** → send a connection request to a new vendor by their phone/email.

**Watch out for:** If you tap on a vendor you've *requested* to connect with but they haven't accepted yet, you'll just see an informational message ("Waiting for them to accept") rather than being taken anywhere.

---

## 2.3 My Khatas Tab

Same list of your connected vendors as the Home tab, but grouped by category (Dairy, Kirana, Salon, etc.) with filter tabs at the top if you shop at more than one type of business.

---

## 2.4 Customer Profile Tab

**What you can tap:**
- **Edit Profile** → change your details.
- **Change Password** → update your password.
- **App Language** → switch languages.
- **Help & Support** → shows a simple pop-up with a support email address (no live chat).
- **Auto-Confirm Entries (Ledger Preferences)** → settings for how payments get auto-approved.
- **Terms & Conditions / Privacy Policy** → legal text.
- **Logout** → asks "are you sure?" first.

**Important — please note:** As a customer, **there is currently no "Delete Account" option anywhere in your Profile screen.** That option only exists for vendors. If you need your account fully deleted during testing, this needs to be done another way (ask your development team) — it's not a button you'll find by browsing the app.

---

## 2.5 Finding and Connecting with a Vendor

### Vendor Search
Type a name or tap a category to browse vendors. Tap a result to see their full profile.

### Vendor Profile
Shows the vendor's details (address, email, UPI ID — tap either to copy it). Tap **"Send Connection Request"** to ask to connect with them (the button changes to "Request Sent" once you've done this, or shows "Already Connected" if you're already linked). If they have a UPI ID, a **"Pay via UPI"** button copies it to your clipboard — it does not open a payment screen directly.

### Responding to a Vendor's Request
If a vendor invites you to connect, tap the notification or dashboard banner to see their info and any message they sent. Tap **"Accept Request"** or **"Decline Request."**

---

## 2.6 Booking Appointments

### Book Appointment
Pick a date from the horizontal strip at the top, then tap an available time slot (full or already-booked slots are shown greyed out and can't be tapped). Confirm your booking with an optional note.

**Watch out for:** If a vendor hasn't set up any time slots for a chosen day, you'll see "No slots available."

### My Bookings (Bookings tab)
Shows your appointments split into Upcoming and Past. Tap **"Cancel"** on an upcoming booking — this asks "are you sure?" before cancelling. This screen automatically refreshes itself every 15 seconds, so if a vendor confirms your booking while you're looking at this screen, it should update on its own.

---

## 2.7 Orders

### My Orders
A list of orders you've placed, with their status (Pending/Confirmed/Delivered/Rejected/Cancelled). Tap one to see full details — as a customer, you can only **view** order details; you can't confirm/reject/mark-delivered yourself (that's for the vendor or their staff).

### Place Order
Tap "Order" on a vendor's tile to build an order: add item rows (name required, quantity/price optional), see a running total, add an optional note, then tap "Place Order."

---

## 2.8 Subscriptions / Scheduled Deliveries (Schedule tab)

**Important:** As a customer, you **cannot start a new subscription yourself** through the app — only the vendor can add you to one of their recurring services (like a daily milk plan). Your Schedule tab is for **viewing** your existing subscriptions and their delivery history only:

- **Active tab** — your current subscriptions, what they include, and your next delivery date.
- **Deliveries tab** — a history of individual deliveries with their status (Scheduled/Delivered/Skipped/Failed). Tap one to see full details, including a photo if the delivery person attached one. There's nothing to tap or change here — it's for viewing only.

---

## 2.9 Membership Plans (Loyalty Programs)

**Where to find this:** Look for a small badge/icon in the top bar of a vendor's Shared Ledger screen — this is currently the *only* place in the app where you can browse and apply for that vendor's membership plans. It isn't listed on your Home screen, Profile, or the vendor's search profile, so it's easy to miss — a tester should be told exactly where to look.

**What you can tap:** Browse the vendor's available plans (name, price, benefits). Tap **"Apply"** on one you want — this sends a request to the vendor, who must approve it before it becomes active. While waiting, the button shows "Request Pending."

---

## 2.10 Shared Ledger (Your Khata with a Vendor)

**What you see:** The vendor's name at the top with a live-connection dot, your balance (who owes whom), filter chips, and the list of transactions.

**What you can tap:**
- **"Record Payment"** → the only way you can add something to the ledger yourself — log a payment you've made (amount, description, optional photo proof).
- **Confirm / Dispute** — these only appear on charges the *vendor* added (never on your own payment entries, which need the vendor's confirmation instead). Tap **Confirm** to accept a charge, or **Dispute** to flag it as wrong (you'll need to type a reason).
- **Export Statement** → generates a PDF of your history with this vendor.
- **Monthly Statement icon** → month-by-month summary.
- **Remove-link icon** → asks "are you sure?" before disconnecting from this vendor.

**Watch out for:** As a customer, **you do not see a "Give Credit" button** — only the vendor can log a charge against your account; you can only log payments.

---

## 2.11 UPI Payment Screen

**Important — this is not a real payment system yet.** Everything about this screen is a simulation for testing purposes:
- Tapping any of the GPay/PhonePe/Paytm/BHIM icons just shows a "coming soon" message — nothing opens.
- Tapping "Pay" waits 2 seconds and **always shows a success screen, no matter what** — there's no real transaction, no real failure path currently possible.

**Please don't mistake the "Payment Successful" message here for a real transfer of money during testing** — nothing is actually being charged yet.

---

## 2.12 Notifications

Two tabs: **All** and **Bookings**. Tap "Mark all read" to clear unread badges. Tapping an individual notification takes you to the relevant screen (e.g. a booking confirmation takes you to My Bookings).

---

## Customer: Things to Double Check

1. **The UPI payment flow is fully simulated — no real money moves, and every payment attempt "succeeds."** Make sure nobody testing this mistakes it for a working payment feature.
2. There's no way for a customer to delete their own account from the app — only vendors have that option currently.
3. Accidentally selecting both "Vendor" and "Customer" on the role-selection screen silently defaults you to Vendor.
4. The "Complete Your Profile" screen has its own separate role toggle (defaulting to Vendor) that doesn't remember what you picked earlier — easy to miss.
5. Denying location permission silently falls back to a default location with no visible warning — check that a sensible address results.
6. There's no customer-facing way to start a new subscription — this can only be initiated by the vendor. If that's not intended, it's worth flagging.
7. Membership plans are only reachable through a small, easy-to-miss icon inside a vendor's ledger screen.
8. "Help & Support" is just a static email address with no live chat or ticket system.
9. One customer screen (Payments tab) currently shows the same fixed test data regardless of which customer account is logged in — worth confirming this shows the correct real data once tested with two different customer accounts.

---

# PART 3 — STAFF / DELIVERY PERSON

Staff accounts are created **by the vendor**, not by signing up directly. A staff member logs in on their own phone but has fewer permissions than the vendor.

## 3.1 How a Staff Member Gets Access (background — done by the vendor)

Before a staff member can log in at all, the **vendor** must:
1. Add them as a staff record (name, phone, role/job title, salary) — this alone does **not** grant app access.
2. Separately flip a switch called **"App Access"** to ON for that staff member. Only after this is switched on can they actually log into the app with their phone number.

**Note for testers:** access is strictly on/off — there's no way to give a staff member partial permissions (e.g. "can collect payment but can't see other customers"). Once access is granted, every staff member gets the exact same set of screens and abilities described below.

## 3.2 Staff Login

1. On the **"Choose Your Role"** screen, there is **no "Staff" option** — a staff member must tap **"Vendor"** (this is just a hint on the next couple of screens and doesn't create a vendor account).
2. Enter the staff member's phone number and verify the OTP code, exactly like a normal login.
3. The app automatically detects that this phone number belongs to a staff account and sends them straight to the **Staff Home** screen — bypassing the normal vendor or customer screens entirely, regardless of which role card was tapped in step 1.

**Watch out for:** It's worth specifically testing what happens if a vendor turns OFF a staff member's app access **while that staff member is still logged in and using the app**, or if they try to log in fresh after access has been revoked — the exact behavior in that situation wasn't fully clear from testing and deserves a dedicated check.

## 3.3 The Staff App's Main Navigation

Once logged in, staff see a bottom bar with exactly **4 tabs: Home, Customers, Deliveries, My Pay.** There is no Reports tab, no Staff Management tab, no Settings tab, and no way to add new customers themselves — these are deliberately not available to staff.

## 3.4 Staff Home ("Today's Overview")

**What you see:** The vendor's business name at the top (not the staff member's own name), four large action buttons, and a short list of customers with their balances.

**What you can tap:**
- **"Quick Delivery"** → search for a customer and record a delivery for them in one quick step.
- **"Orders"** → see orders waiting to be delivered.
- **"Record Delivery"** → opens a form to log a delivery (pick the customer from a list).
- **"Collect Payment"** → opens a form to log a payment received.
- **"View All"** → the full customer list.
- **A customer's name** → opens their full khata/ledger.

**Watch out for:** If the vendor hasn't linked any customers yet, tapping "Record Delivery" or "Collect Payment" **does absolutely nothing — no message, nothing** — this can look like a broken button if there's no test data set up yet.

## 3.5 Customers Tab

A full list of the vendor's customers, each showing their balance due. Tap the truck icon next to a name to quickly record a delivery for them, or tap the arrow to open their full ledger.

## 3.6 Recording a Delivery or Payment (the pop-up form)

This form appears from several places (Home, Customers, Quick Delivery) and has two modes:

**Delivery mode:** Pick a customer (if not already chosen), enter an item name, quantity, and price — the total calculates automatically. Optionally attach a photo. Tap **"Deliver & Charge"**.

**Payment mode:** Pick a customer, enter an amount and a required note, optionally attach a photo. Tap **"Record Payment"**.

**What happens:** A success message confirms it, the form closes, and the customer's balance updates. If something goes wrong, an error message explains why and the form stays open so you can try again.

**Watch out for:** The submit button only becomes tappable once all required fields are properly filled in (for delivery: item name + quantity above 0 + price above 0; for payment: amount above 0 + a note). If a photo fails to upload, you'll just see a generic "Photo upload failed" message with no explanation of why.

## 3.7 Quick Delivery

Search customers by name or phone; each result shows their usual default order if the vendor has set one up (e.g. "2 Litre Milk"). Tap a customer to open the delivery form, pre-filled for them, so you can quickly confirm and submit.

## 3.8 Orders (staff view)

Shows orders that are confirmed and waiting to be delivered. Tap a card, or its "Deliver" button, to open the order and mark it delivered.

**Watch out for:** Once an order is marked delivered or cancelled, it disappears from this list right away — so if you can't find an order you just handled, that's expected, not a bug.

## 3.9 Today's Deliveries (subscription-based, not one-off orders)

**Important distinction:** this is a *different* feature from "Orders" above — this one is for recurring/subscription deliveries (like a daily milk round), while Orders is for one-off purchases. Both use a similar truck icon and "Deliver" language, so **be careful not to confuse the two features while testing.**

**What you can tap:**
- **Filter icon** → filter by customer/service name, status, date, or distance from your current location (requires location permission).
- **Call chip** → opens your phone dialer with the customer's number.
- **Address chip** → opens Maps.
- **"Skip"** → asks "are you sure?" before marking a delivery skipped for today.
- **"Delivered"** → opens the Confirm Delivery screen.

**Watch out for:** A delivery that isn't due yet (e.g. scheduled for 6pm, viewed at 9am) shows as "Upcoming" with **no buttons at all** — you can't act on it early. This is by design, not a bug.

## 3.10 Confirm Delivery Screen

Shows read-only details (customer, items, total, your name as "delivered by"). **You must take or choose a photo before you're able to tap "Confirm Delivery" — there is no way to skip this requirement.** Once confirmed, the delivery is automatically added to the customer's ledger with the photo attached.

**Watch out for:** Make sure you have a working camera or test photos ready before testing this screen — there's genuinely no way past the photo requirement.

## 3.11 My Pay

**What you see:** Your own pay summary (unpaid salary, any advance you've taken), a section to manage your own personal payment QR code (so customers or the vendor can pay you directly), and a history of your past salary payments/advances.

**What you can tap:**
- **"Show My QR"** → view your payment QR code full-size (only available once you've uploaded one).
- **"Upload QR" / "Replace QR"** → choose a photo of your QR code from your gallery.
- **⋮ menu (top-right)** → **"Log Out"** (asks "are you sure?") or **"Delete Account"** (asks for confirmation with a clear permanent-deletion warning).

## 3.12 Shared Ledger (viewing a customer's khata as staff)

When you tap into a specific customer, you land on the same screen the vendor uses, but with some differences:

**What's different for staff:**
- **No "Monthly Statement" icon** — this is hidden for staff.
- **No "Give Credit" button** — staff cannot log a multi-item bill; only **"Record Payment"** is available.
- **Confirm/Dispute buttons never appear for staff at all**, even on entries the vendor created — only the vendor or the customer sees those buttons, depending on who created the entry.
- Staff **can** attach or replace a proof photo on an existing entry, as long as it isn't already confirmed/disputed.
- **Staff can still see and use the "Unlink/Remove" icon**, the same one the vendor uses to disconnect from a customer entirely. **This is worth double-checking with your team** — it appears staff currently have the ability to disconnect a vendor's customer relationship, which may be more access than intended for a delivery role.

## 3.13 Deliveries (inside a customer's ledger)

A read-only filtered list showing just the delivery-type entries for that customer — for viewing history only, no actions here beyond opening an entry's details.

---

## Staff/Delivery: Things to Double Check

1. **It wasn't fully confirmed what happens if a vendor revokes a staff member's app access while they're still logged in** — test this directly: log in as staff, have the vendor turn off their access, and see if the staff member is immediately blocked or continues working until they try to log in again.
2. **Staff currently have access to the "Unlink Customer" button** in the Shared Ledger screen, the same one the vendor uses — this may be more access than a delivery role should have, since it could let a staff member accidentally (or deliberately) disconnect a vendor's customer.
3. Staff can attach or replace proof photos on any unlocked ledger entry, effectively the same photo-editing rights as the vendor — confirm this is intentional.
4. Tapping "Record Delivery" or "Collect Payment" on Staff Home does nothing at all if there are no customers linked yet — no error message.
5. Photo upload failures show only a generic error with no explanation.
6. Confirming a delivery absolutely requires a photo, with zero exceptions — good to know in advance so testing isn't blocked by a missing camera.
7. There's no "Staff" option on the role-selection screen — a staff member must tap "Vendor" to log in, which could be confusing wording for someone doing a delivery job.
8. The "Deliveries" tab label in the staff bottom navigation doesn't change when you switch the app's language, unlike the other three tabs.
9. "Orders" (one-off) and "Today's Deliveries" (recurring/subscription) are two separate features that look similar — be careful not to mix them up while testing.

---

# Cross-Cutting Issues (Show Up Across More Than One Role)

These patterns were noticed in multiple places across the app and are worth a dedicated testing pass on their own, rather than treating each instance as a one-off:

1. **Silent failures are the most common issue in the app.** Many forms (Add Staff, Pay Salary, Add Advance, Create Service, Subscribe Customer, Bulk Charge product creation, Record Payment, Confirm, Dispute, and Voice Entry confirmation) will do **absolutely nothing** — no error, no message — if you leave a required field blank or if the save fails due to no internet connection. A non-technical user will read this as "the app is broken" or "my button didn't work." **This is the single highest-value thing to test systematically: try every "Save," "Submit," or "Confirm" button in the app with blank fields and with your internet turned off, and note anywhere nothing visibly happens.**
2. **Confirmation dialogs ("are you sure?") are inconsistent.** Some clearly risky actions ask for confirmation (Delete Staff, Delete Membership Plan, Remove Ledger Link, Cancel Booking) while similarly risky ones don't (Revoke Staff App Access, Remove a Subscriber, Deactivate a Membership Plan, Decline a Membership Request, Delete a UPI ID, Switch a Customer's Membership Plan). Worth a full pass checking which destructive actions have a safety net and which don't.
3. **Two features exist in the app's code but can't currently be reached through normal navigation**: "Help & Support" isn't wired to anything, and "Scan Bill" (photo-to-khata-entry) has no button anywhere leading to it — and isn't functional yet even if reached directly (it uses fake placeholder data).
4. **The UPI payment screen is a complete simulation** — no real money moves, and every attempt to pay "succeeds" automatically. Testers should be told this clearly so no one mistakes it for a working payment feature.
5. **Editing isn't possible for some things you'd expect to edit** — once created, Staff records and Scheduled Services can only be deleted and recreated, not corrected.
6. **Error message quality varies a lot from screen to screen** — some show a friendly message, some show raw technical error text, and some show none at all. Worth flagging to the development team as a general polish item once the missing-message issues above are fixed.

---

*This guide was produced by reading the app's actual screen code directly (not just its documentation or comments), organized by the three user roles: Vendor, Customer, and Staff/Delivery. It reflects the app's behavior as of the current codebase and should be re-generated if major screens are added or changed.*
</content>
