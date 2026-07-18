// server/wordserve.js - serveur de mots FTW (port 16385)
// sert /words/<lang>?letter=x&limit=N depuis words/words_<lang>.lua
import { readFileSync } from "fs";

const PORT = 16385;

function loadWords(lang) {
  try {
    const raw = readFileSync(new URL(`../words/words_${lang}.lua`, import.meta.url), "utf8");
    const arr = raw.match(/"(.*?)"/g) || [];
    return arr.map(s => s.slice(1, -1));
  } catch { return []; }
}

const cache = {};
function getLang(lang) {
  lang = lang || "all";
  if (!cache[lang]) cache[lang] = loadWords(lang);
  return cache[lang];
}

Bun.serve({
  port: PORT,
  fetch(req) {
    const url = new URL(req.url);
    if (url.pathname.startsWith("/words/")) {
      const lang = url.pathname.split("/")[2] || "all";
      const letter = (url.searchParams.get("letter") || "").toLowerCase();
      const limit = parseInt(url.searchParams.get("limit") || "200");
      let words = getLang(lang);
      if (letter) words = words.filter(w => w.startsWith(letter));
      words.sort((a, b) => a.length - b.length);
      if (limit > 0) words = words.slice(0, limit);
      return Response.json({ lang, letter, count: words.length, words });
    }
    if (url.pathname === "/health") return Response.json({ ok: true });
    return new Response("FTW WordServe", { status: 200 });
  }
});

console.log(`WordServe on http://localhost:${PORT}`);
