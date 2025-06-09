export interface ChallengeProps {
    title: string;
    value: string | number;
    description: string;
    claimed?: boolean;
};

export interface StatsProps {
    totalEarned: number;
    longestFish: number;
    totalFish: number;
};

export interface Base {
    nickname: string;
    challenges: ChallengeProps[];
};