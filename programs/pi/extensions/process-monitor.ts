import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import assert from "node:assert/strict";

const ASSESSMENT =
  "Briefly assess whether this shows useful progress, ordinary waiting, or a possible stall/deadlock. Be explicit about uncertainty: activity is not proof of useful work, and one unchanged sample is not proof of deadlock. Do not run diagnostic checks unless the user asks; if investigation would interrupt current work, offer a background session via session_handoff.";

const COMPLETION =
  "Tell the user this Pi-started process completed and report its exit code/signal from the watcher message. Suggest 2–3 task-specific lightweight verification checks, but do not run them unless the user asks.";

function instructionFor(content: string): string {
  return content.includes("PROCESS EXITED") ? COMPLETION : ASSESSMENT;
}

if (process.env.PI_PROCESS_MONITOR_SELF_TEST === "1") {
  assert.equal(instructionFor("PROCESS EXITED (code=0 signal=none)"), COMPLETION);
  assert.equal(instructionFor("heartbeat: still running"), ASSESSMENT);
}

export default function (pi: ExtensionAPI) {
  pi.on("context", (event) => {
    const message = event.messages.at(-1);
    if (message?.role !== "custom" || message.customType !== "monitor" || typeof message.content !== "string") return;

    const instruction = instructionFor(message.content);
    return {
      messages: [
        ...event.messages.slice(0, -1),
        { ...message, content: `${message.content}\n\nMonitor assessment instruction: ${instruction}` },
      ],
    };
  });
}
