import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

// Select any discovered Pi theme with PI_THEME=<name>.
const FALLBACK_THEME = "tokyo-city";

function selectTheme(ctx: ExtensionContext): void {
  if (ctx.mode !== "tui") return;

  const requestedTheme = process.env.PI_THEME?.trim();
  const themeName = requestedTheme && ctx.ui.getTheme(requestedTheme) ? requestedTheme : FALLBACK_THEME;
  const result = ctx.ui.setTheme(themeName);

  if (!result.success && themeName !== FALLBACK_THEME) {
    ctx.ui.setTheme(FALLBACK_THEME);
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => selectTheme(ctx));
}
