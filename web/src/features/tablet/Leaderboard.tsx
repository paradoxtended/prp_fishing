import React from "react";
import { useLocales } from "../../providers/LocaleProvider";
import Loader from './Loader'
import type { LeaderboardProps } from "../../typings/tablet";
import { setClipboard } from "../../utils/setClipboard";

type LeaderboardProperties = {
    leaderboard: LeaderboardProps[];
};

const Leaderboard: React.FC<LeaderboardProperties> = ({ leaderboard }) => {
    const [visible, setVisible] = React.useState<boolean>(false);
    const [searchTerm, setSearchTerm] = React.useState<string>('');
    const [sortKey, setSortKey] = React.useState<'fishCaught' | 'earned' | 'longestFish'>('fishCaught');
    const [sortDirection, setSortDirection] = React.useState<'asc' | 'desc'>('desc');
    const { locale } = useLocales();

    const handleSort = (key: 'fishCaught' | 'earned' | 'longestFish') => {
        if (sortKey === key) {
            setSortDirection(prev => (prev === 'asc' ? 'desc' : 'asc'));
        } else {
            setSortKey(key);
            setSortDirection('desc');
        }
    };

    React.useEffect(() => {
        if (visible) return;

        setSearchTerm('');
        setTimeout(() => setVisible(true), 500);
    }, [visible]);

    const filteredLeaderboard = React.useMemo(() => {
        const withIds = leaderboard
            .sort((a, b) => {
                const valueA = a[sortKey];
                const valueB = b[sortKey];

                if (typeof valueA === 'number' && typeof valueB === 'number') {
                    return sortDirection === 'asc' ? valueA - valueB : valueB - valueA;
                };

                return 0;
            })
            .map((item, index) => ({
                ...item,
                id: index + 1,
            }));

        let filtered = withIds.filter(entry =>
            entry.name.toLowerCase().includes(searchTerm.toLowerCase())
        );

        return filtered;
    }, [leaderboard, searchTerm, sortKey, sortDirection]);

    const handleSearch = (e: any) => {
        setSearchTerm(e.target.value);
    };

    return (
        visible ? (
            <div className="leaderboard-page">
                <p className="title-page">{locale.ui.leaderboard}</p>
                <p className="description-page">{locale.ui.leaderboard_description}</p>
                <input type="text" onChange={handleSearch} placeholder={locale.ui.lb_placeholder}  />
                <div className="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>{locale.ui.lb_username}</th>
                                <th onClick={() => handleSort('longestFish')}>
                                {locale.ui.lb_longest_fish} {sortKey === 'longestFish' && (sortDirection === 'asc' ? '▲' : '▼')}
                                </th>
                                <th onClick={() => handleSort('earned')}>
                                {locale.ui.lb_total_earned} {sortKey === 'earned' && (sortDirection === 'asc' ? '▲' : '▼')}
                                </th>
                                <th onClick={() => handleSort('fishCaught')}>
                                {locale.ui.lb_fish_caught} {sortKey === 'fishCaught' && (sortDirection === 'asc' ? '▲' : '▼')}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredLeaderboard.map((data, index) => (
                                <tr key={index} style={data.me ? { backgroundColor: '#83cc1630' } : {}}>
                                    <td>#{data.id}</td>
                                    <td style={{ cursor: 'pointer' }} onClick={() => setClipboard(data.name)}>{data.name}</td>
                                    <td>{data.longestFish}"</td>
                                    <td>${data.earned.toLocaleString('en-US', { maximumFractionDigits: 0 })}</td>
                                    <td>{data.fishCaught}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        ) : <Loader />
    );
};

export default Leaderboard