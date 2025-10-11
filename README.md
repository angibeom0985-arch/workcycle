<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

# Run and deploy your AI Studio app

This contains everything you need to run your app locally.

View your app in AI Studio: https://ai.studio/apps/drive/12DUH6SMXmNM9JZupXYytqqA2kt0YGXY7

## Run Locally

**Prerequisites:**  Node.js


1. Install dependencies:
   `npm install`
2. Set the `GEMINI_API_KEY` in [.env.local](.env.local) to your Gemini API key
3. Run the app:
   `npm run dev`

## Deploying to Vercel (GitHub integration)

This project was created in AI Studio and uses Vite + React. The steps below will help you create a GitHub repository, push the project, and deploy it to Vercel with a custom domain `workcycle.money-hotissue.com`.

1. Initialize git (if you haven't already) and make an initial commit:

   ```powershell
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. Create a GitHub repository (via web UI or `gh` CLI) and add it as a remote, then push:

   ```powershell
   git remote add origin https://github.com/<your-username>/<repo-name>.git
   git branch -M main
   git push -u origin main
   ```

3. On Vercel:
   - Create a new project and import from your GitHub repository.
   - Build command: `npm run build`
   - Output directory: `dist`
   - Set environment variables (Project Settings -> Environment Variables):
     - `GEMINI_API_KEY` = <your key>

4. Add your custom domain in Vercel (Project -> Domains):
   - Add `workcycle.money-hotissue.com`.
   - Follow DNS instructions provided by Vercel to point your domain (usually add CNAME or ALIAS records).

Notes:
- The project already includes a `vercel.json` for static builds and an `index.css` prepared for Tailwind.
- Make sure to remove any AI Studio-specific importmaps (already cleaned) so the app uses local `react` packages.

If you want, I can generate the exact Git commands for creating a GitHub repo with the `gh` CLI and show the DNS steps for common registrars.
