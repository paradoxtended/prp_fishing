import { useEffect, useState } from "react";
import type { BoatProps } from "../../../../typings/tablet";
import Loader from "../Loader";
import { useLocales } from "../../../../providers/LocaleProvider";
import { fetchNui } from "../../../../utils/fetchNui";

type RentProp = {
    vehicles: BoatProps[]
};

const Rent: React.FC<RentProp> = ({ vehicles }) => {
    const { locale } = useLocales();
    const [visible, setVisible] = useState<boolean>(false);

    useEffect(() => {
        if (visible) return;
        setTimeout(() => setVisible(true), 500);
    }, [visible]);

    return (
        visible ? (
            <div className="rent-page">
                <p className="rent-title">{locale.ui.rent_boat}</p>
                <p className="rent-description">{locale.ui.rent_boat_description}</p>
                <section>
                    {vehicles.map((vehicle, index) => (
                        <div className="card" key={index}>
                            <div>
                                <p className="title">{vehicle.name}</p>
                                {vehicle?.description && <p className="description">{vehicle.description}</p>}
                                <p className="price">{locale.ui.price}: <span>${vehicle.price.toLocaleString('en-US')}</span></p>
                                <button onClick={() => fetchNui('rentVehicle', index)}>{locale.ui.rent_boat}</button>
                            </div>
                            {vehicle?.image && (
                                <div><img src={vehicle.image} /></div>
                            )}
                        </div>
                    ))}
                </section>
            </div>
        ) : <Loader />
    )
};

export default Rent