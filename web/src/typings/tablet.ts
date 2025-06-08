export interface TabletProps {
    myStats: {
        fishesCaught: { [fishName: string]: { amount: number, longest: number } } | null;
    }
}