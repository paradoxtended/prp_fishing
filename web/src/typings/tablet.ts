export interface ChallengeProps {
    title: string;
    value: string | number;
    description: string;
    claimed?: boolean;
};

export interface Base {
    nickname: string;
    challenges: ChallengeProps[]
};