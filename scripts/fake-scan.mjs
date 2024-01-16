#!/usr/bin/env zx

if (argv._.length !== 3) {
  console.log("");
  console.log("Please provide input and output files:");
  console.log("");
  console.log("  scanned-pdf input.pdf output.pdf");
  console.log("");
  process.exit(1);
}

$.verbose = false;

const input = argv._[1];
const output = argv._[2];

const rotationRange = 0.4;
const shiftRange = 0.01; // 1 = 100% width
const outRes = 150;

async function getPages() {
  const result = await $`pdfinfo ${input} | awk '/^Pages:/ { print $2 }'`;
  return Number(result.stdout);
}

async function getDocInfos() {
  const result = await $`identify -format "%x:%w:%h\n" ${input} | head -n1`;
  return result.stdout.trim().split(":").map(Number);
}

console.log("");
console.log(`Source: ${input}`);
console.log(`Save as: ${output}`);
console.log("");
console.log(`Fetching PDF info…`);

const [pages, [inRes, inWidth, inHeight]] = await Promise.all([
  getPages(),
  getDocInfos(),
]);

console.log("");
console.log("Width:", inWidth);
console.log("Height:", inHeight);
console.log("Resolution:", inRes);
console.log("Pages:", pages);

const scaling = outRes / inRes;

const rotationArgs = Array.from({ length: pages }).flatMap((_, index) => {
  const rotateValue = -(rotationRange / 2) + rotationRange * Math.random();
  const shift = [
    Math.round(Math.random() * inWidth * scaling * shiftRange * 100) / 100,
    Math.round(Math.random() * inHeight * scaling * shiftRange * 100) / 100,
  ];
  // const center = [
  //   (inWidth * scaling) / 2,
  //   (inHeight * scaling) / 2,
  // ];
  return [
    "(",
    "-clone",
    index,
    "-distort",
    "ScaleRotateTranslate",
    `0,0 1 ${rotateValue} ${shift.join(",")}`,
    "+repage",
    ")",
    "-swap",
    `${pages},${index}`,
    "+delete",
  ];
});

console.log("");
console.log("Converting…");
console.log("");

const convertArgs = [
  "-define",
  "pdf:Title=",
  "-density",
  "150",
  "-compress",
  "Zip",
  input,
  "-quiet",
  "-attenuate",
  "0.7",
  "+noise",
  "Gaussian",
  "-colorspace",
  "gray",
  ...rotationArgs,
  output,
];

const result = await $`convert ${convertArgs}`;

console.log(`Saved to ${output}.`);
console.log("");
