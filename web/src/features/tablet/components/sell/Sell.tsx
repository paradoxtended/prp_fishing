import { useEffect, useState } from "react";
import Loader from "../Loader";

const Sell: React.FC = () => {
    const [visible, setVisible] = useState(false);

    useEffect(() => {
        if (visible) return;
        setTimeout(() => setVisible(true), 500);
    }, [visible]);

    // todo create a selling page where player can insert the fishes into the selling container containing 16 slots (4x4) :eyes:
    return (
        visible ? (
            <div className="sell-page">
                
            </div>
        ) : <Loader />
    )
};

export default Sell