/** @type {import('tailwindcss').Config} */

export default {

    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            boxShadow: {
                'custom-raise': '0 0.5em 0.5em -0.4em var(--hover)',
            },
            translate: {
                'custom-raise': '-0.25em',
            },
        },
        fontFamily: {
            'mono': 'JetBrains Mono'
        },
        plugins: [
            require('tailwind-scrollbar'),
        ]
    }
}

