---
categories:
- code
date: "2026-07-06T00:00:00Z"
title: Fractal Tree (190)
---

<script src="https://cdn.jsdelivr.net/npm/p5@1.9.0/lib/p5.min.js"></script>

<center>
    <div id="fractal"></div>
</center>
    
<script>
TRUNK_SIZE = 200;
MIN_LEN = [2, 6];
NB_BRANCH = [1, 6];
BRANCH_DECAY = [0.3, 0.8];
ROTATION = [0.3, 0.8];
INITIAL_STROKE = 10;
STROKE_FACTOR = 1.1;
MIN_STROKE = 0.1;
MAX_STROKE = 0.4;
INITIAL_ROTATION = [-0.05, 0.05];
COLOR = 160;

var treeSeed = 190;
      
function abetween(boundaries) {
    return random(boundaries[0], boundaries[1]);
}

function setup() {
    container = document.getElementById('fractal');
    var c = createCanvas(700, 800);
    c.parent(container);
    randomSeed(treeSeed * 2654435761 % 2147483647);
    noLoop();
}

function drawSeed(seed) {
    fill(COLOR * 0.5);
    textAlign(RIGHT, TOP);
    textSize(10);
    text("#" + seed, width - 10, 10);
}

function draw() {
    clear();
    drawSeed(treeSeed);
    strokeCap(SQUARE);
    strokeWeight(1.0);
    drawTree();
}

function drawTree() {
    stroke(COLOR);
    translate(width / 2, height);

    rotate(abetween(INITIAL_ROTATION) * PI /2);
            
    var size = TRUNK_SIZE;
    drawBranch(size, INITIAL_STROKE);
}

function branchIndices(nb_branches) {
    var indices = [];

    var start = ROTATION[0];
    var end = ROTATION[1];

    for (var i = 0; i < nb_branches; i += 1) {
        var remaining = end - start;
        var indice = random(start, start + remaining / (nb_branches - i));

        start = indice;
        indices.push(indice);
    }

    return shuffle(indices);
}

function drawBranch(len, stroke) {
    if (len <= abetween(MIN_LEN)) {
        return;
    };

    drawLine(len, stroke);
    translate(0, -len);

    var opening = PI / 2;
    var branches = abetween(NB_BRANCH);
    var indices = branchIndices(branches);

    for (var i = 0; i < branches; i += 1) {
        push();
        rotate(-PI / 4 + (PI / 2) * indices[i]);
        drawBranch(len * abetween(BRANCH_DECAY), stroke / STROKE_FACTOR);
        pop();
    }
}

function drawLine(len, stroke) {
    strokeWeight(min(MAX_STROKE, max(MIN_STROKE, stroke)));
    line(0, 0, 0, -len);
}
</script>
