#!/usr/bin/env node

const fs = require("fs");

function camelCaseFromDashes(str) {
  return str.replace(/-([^-])/g, (g) => g[1].toUpperCase());
}

function transform(str) {
  const lines = str.split("\n");

  const indentation = " ".repeat(
    lines.length > 0 ? (lines?.[0].match(/^ */)[0] ?? "").length : 0
  );

  return lines
    .map((line) => {
      line = line.trim();
      if (!line) {
        return "";
      }
      if (
        // captures:
        // css={css`
        (line.startsWith("css=") && line.includes("css`")) ||
        // captures:
        // css={
        //   css`
        // startsWith is used to avoid capturing e.g. css`10gu` in the value
        line.startsWith("css`")
      ) {
        return indentation + line.replace(/css`/, "({");
      }
      if (line.endsWith("`}")) {
        return indentation + line.replace(/`}/, "})}");
      }

      if (line.endsWith("{") && !line.includes("css=")) {
        return indentation + `"${line.replace(/{$/, "").trim()}": {`;
      }
      if (line.endsWith("}")) {
        return indentation + line.replace(/}/, "},");
      }

      const colonIndex = line.indexOf(":");
      if (colonIndex === -1) {
        return line;
      }

      let [prop, value] = [
        line.slice(0, colonIndex),
        line.slice(colonIndex + 1),
      ];

      prop = camelCaseFromDashes(prop);
      value = value.trim().replace(/;$/, "");

      // single dynamic values, e.g. background: ${colors.background}
      if (
        value.startsWith("${") &&
        value.endsWith("}") &&
        !value.match(/^.+\${/) // excludes multiple ${} in the value
      ) {
        value = value.slice(2, -1) + ",";
      } else {
        value = value.includes("${")
          ? `\`${value}\`,`
          : `"${value.replace(/"/g, '\\"')}",`;
      }

      return `${indentation}  ${prop}: ${value}`;
    })
    .join("\n")
    .trim();
}

const stdinBuffer = fs.readFileSync(process.stdin.fd);

console.log(transform(stdinBuffer.toString()));

// transform(`
//         css={css\`
//           position: absolute;
//           inset: auto 0 3gu auto;
//           inset: auto 0 \${4 * gu}px auto;
//           display: flex;
//           flex-direction: column;
//           gap: 1.5gu;
//           color: \${colors.accent};
//         \`}
// `)
