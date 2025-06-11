import React from "react";
import { useLocales } from "../../../providers/LocaleProvider";
import type { ChallengeProps, Base } from "../../../typings/tablet";
import { fetchNui } from "../../../utils/fetchNui";
import Loader from "./Loader";

type MainPageProps = {
    setPage: (page: string) => void;
    loading?: boolean
};

const icons: string[] = ['trophy', 'award', 'medal'];

const MainPage: React.FC<MainPageProps> = ({ setPage, loading }) => {
    const [visible, setVisible] = React.useState<boolean>(false);
    const { locale } = useLocales();
    const [nickname, setNickname] = React.useState<string>('Ravage');
    const [challenges, setChallenges] = React.useState<ChallengeProps[]>([]);

    React.useEffect(() => {
        const initUser = async () => {
            const data: Base = await fetchNui('getFishingData');
            setChallenges(data.challenges);
            setNickname(data.nickname);
        };

        initUser();
    }, []);

    React.useEffect(() => {
        if (visible) return;
        if (loading) setVisible(true);
    
        setTimeout(() => setVisible(true), 500)
    }, [visible]);

    const handleChallenge = async(index: number, type?: string) => {
        if (type === 'reload')
            fetchNui('reloadDailyChallenge', index);
        else if (type === 'claim')
            fetchNui('claimChallenge', index)

        setTimeout(async () => {
            const data: Base = await fetchNui('getFishingData');
            setChallenges(data.challenges);
            setNickname(data.nickname);
        }, 50)
    };

    return (
        visible && !loading ? (
            <div className="main-page">
                <div className="left-side">
                    <p className="welcome">{locale.ui.welcome}</p>
                    <p className="username">{nickname}</p>

                    <div className="cards">
                        <div className="card" onClick={() => setPage('stats')}>
                            <img src='./statistics.png' />
                            <p className="label">{locale.ui.statistics}</p>
                        </div>
                        <div className="card" onClick={() => setPage('leaderboard')}>
                            <img src='./leaderboard.png' />
                            <p className="label">{locale.ui.leaderboard}</p>
                        </div>
                        <div className="card" onClick={() => setPage('shop')}>
                            <img src='./shop.png' />
                            <p className="label">{locale.ui.shop}</p>
                        </div>
                        <div className="card" onClick={() => setPage('sell')}>
                            <img src='./sell.png' />
                            <p className="label">{locale.ui.sell}</p>
                        </div>
                    </div>
                </div>
                <div className="right-side">
                    <p className="title">{locale.ui.ongoing_challenges}</p>
                    <div className="cards">
                        {challenges.map((challenge, index) => (
                            <div className={`card ${challenge?.claimed && 'claimed'}`} key={index}>
                                <div className="label"><i className={`fa-solid fa-${icons[index % icons.length]}`}></i> {challenge.title}</div>
                                <div className="main-text">{challenge.value}</div>
                                <div className="description">{challenge.description}</div>
                                <div className="buttons">
                                    <button onClick={() => handleChallenge(index, 'claim')}
                                        disabled={challenge?.claimed}
                                    >
                                        {!challenge?.claimed ? locale.ui.claim : locale.ui.claimed}
                                    </button>
                                    <button onClick={() => handleChallenge(index, 'reload')}>{locale.ui.reload}</button>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        ) : <Loader />
    )
};

export default MainPage