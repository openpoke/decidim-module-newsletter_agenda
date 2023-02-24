const selectElement = document.getElementById('box-number');
const containerElement = document.getElementById('box-container');
const firstBox = document.getElementById('box1');

selectElement.addEventListener('change', function() {
    const numBoxes = selectElement.value;

    let nextBox = firstBox.nextElementSibling;
    while (nextBox) {
        containerElement.removeChild(nextBox);
        nextBox = firstBox.nextElementSibling;
    }

    for (let i = 2; i <= numBoxes; i++) {
        const newBox = firstBox.cloneNode(true);
        newBox.id = 'box' + i;
        newBox.querySelector('.box-title').textContent = 'Box #' + i;

        const fields = newBox.querySelectorAll('input[type="text"], input[type="file"], textarea');
        for (let j = 0; j < fields.length; j++) {
            const oldName = fields[j].getAttribute('name');
            const newName = oldName.replace(/(\d+)/, i);
            fields[j].setAttribute('name', newName);
        }

        containerElement.appendChild(newBox);
    }
});
