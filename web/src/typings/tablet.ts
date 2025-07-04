export interface ChallengeProps {
    title: string;
    value: string | number;
    description: string;
    claimed?: boolean;
};

export interface StatsProps {
    earned: number;
    longestFish: number;
    fishCaught: number;
};

export interface LeaderboardProps {
    name: string;
    longestFish: number;
    earned: number;
    fishCaught: number;
    me?: boolean;
    id?: number; // Generated by function!!
};

export interface Base {
    nickname: string;
    challenges: ChallengeProps[];
};

export interface ShopProps {
    name: string;
    label: string;
    imageUrl: string;
    price: number;
    rarity?: 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary';
};

export interface SellProps {
    label: string;
    imageUrl: string;
    rarity?: 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary';
    price: number;
    name?: string;
    length: number;
    metadata?: { label?: string; value: any; }[]
};

export interface TabletProps {
    leaderboard: LeaderboardProps[];
    statistics: StatsProps;
    shop: ShopProps[];
    sell: SellProps[];
    boats: BoatProps[];
};

export interface CartProps {
    name: string;
    count: number
}

export interface BoatProps {
    name: string;
    price: number;
    image?: string;
    description?: string;
}