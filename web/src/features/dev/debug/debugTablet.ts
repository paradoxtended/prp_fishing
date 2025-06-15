import type { TabletProps } from '../../../typings/tablet';
import { debugData } from '../../../utils/debugData';

export const debugTablet = () => {
    debugData<TabletProps>([
        {
            action: 'openTablet',
            data: {
                leaderboard: [
                    { name: 'Esteban Casados', longestFish: 24.51, earned: 2643.51, fishCaught: 42, me: true },
                    { name: 'Mila Novak', longestFish: 18.32, earned: 1743.23, fishCaught: 36 },
                    { name: 'Lars Pettersson', longestFish: 30.14, earned: 3021.10, fishCaught: 51 },
                    { name: 'Anaïs Dupont', longestFish: 22.87, earned: 1987.65, fishCaught: 40 },
                    { name: 'Riko Yamamoto', longestFish: 25.67, earned: 2891.75, fishCaught: 48 },
                    { name: 'Jonas Keller', longestFish: 19.45, earned: 1543.90, fishCaught: 33 },
                    { name: 'Lucia Varga', longestFish: 28.12, earned: 3112.33, fishCaught: 52 },
                    { name: 'Mateo Hernández', longestFish: 21.75, earned: 2345.60, fishCaught: 39 },
                    { name: 'Kira Johansson', longestFish: 23.11, earned: 2632.80, fishCaught: 44 },
                    { name: 'Daniel O\'Connor', longestFish: 17.89, earned: 1422.35, fishCaught: 28 },
                    { name: 'Niko Popov', longestFish: 26.04, earned: 2770.50, fishCaught: 46 },
                    { name: 'Hanna Schmidt', longestFish: 20.98, earned: 2098.10, fishCaught: 38 },
                    { name: 'Leo Moretti', longestFish: 29.65, earned: 3295.20, fishCaught: 55 },
                    { name: 'Sofia Dimitrova', longestFish: 22.33, earned: 2204.75, fishCaught: 41 },
                    { name: 'Thiago Costa', longestFish: 18.76, earned: 1823.60, fishCaught: 35 },
                    { name: 'Olga Ivanova', longestFish: 27.15, earned: 2942.90, fishCaught: 49 },
                    { name: 'Alex Walker', longestFish: 24.02, earned: 2517.20, fishCaught: 43 },
                    { name: 'Ines Ferreira', longestFish: 23.78, earned: 2470.85, fishCaught: 42 },
                    { name: 'Martin Horák', longestFish: 20.44, earned: 2054.25, fishCaught: 37 },
                    { name: 'Emily Nguyen', longestFish: 21.23, earned: 2129.40, fishCaught: 39 },
                    { name: 'Tobias Weber', longestFish: 26.91, earned: 2888.60, fishCaught: 47 }
                ],
                statistics: {
                    earned: 5784,
                    fishCaught: 53,
                    longestFish: 24.62
                },
                shop: [
                    { name: 'fishing_rod', label: 'Basic Fishing Rod', imageUrl: './public/titanium_rod.png', price: 150, rarity: 'uncommon' },
                    { name: 'titan_fishing_rod', label: 'Pro Fishing Rod', imageUrl: './public/titanium_rod.png', price: 450, rarity: 'epic' },
                    { name: 'worms', label: 'Worms', imageUrl: './public/worms.png', price: 1, rarity: 'common' },
                    { name: 'artificial_bait', label: 'Artificial Bait', imageUrl: './public/artificial_bait.png', price: 2, rarity: 'uncommon' },
                    { name: 'cooler_box', label: 'Cooler Box', imageUrl: './public/fish_cooler_box_small.png', price: 300, rarity: 'rare' },
                    { name: 'large_cooler_box', label: 'Large Cooler Box', imageUrl: './public/fish_cooler_box_small.png', price: 800, rarity: 'legendary' },
                ],
                sell: [
                    { label: 'Trout', imageUrl: './public/trout.png', price: 5.5, length: 4.24, rarity: 'uncommon', metadata: [
                        { label: 'Fish length', value: 4.24 + '"' }
                    ] },
                    { label: 'Piranha', imageUrl: './public/piranha.png', price: 8.5, length: 6.74, rarity: 'rare', metadata: [
                        { label: 'Fish length', value: 6.74 + '"' }
                    ] },
                ],
                boats: [
                    { name: 'Speeder', price: 150, image: 'https://i.postimg.cc/mDSqWj4P/164px-Speeder.webp', description: 'One of the smaller boats but on the other hand it is extremly fast.' },
                    { name: 'Dinghy', price: 450, image: 'https://i.postimg.cc/ZKzjZgj0/164px-Dinghy2.webp'  },
                    { name: 'Tug', price: 750, image: 'https://i.postimg.cc/jq7vpKHG/164px-Tug.webp', description: 'A slow but giant boat. Better for further destination.' }
                ]
            }
        }
    ]);
};