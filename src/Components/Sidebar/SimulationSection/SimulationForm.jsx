import { useEffect } from "react";
import { useForm } from "react-hook-form";
import toast from "react-hot-toast";

/**
 * SimulationForm Component
 * @description Form for adding/editing address data.
 * @param {Object} props - Component properties.
 * @param {Function} props.onSubmit - Function to handle form submission.
 * @param {Function} props.onClose - Function to handle closing the form.
 * @param {Object} props.initialValues - Initial values for the form fields.
 * @returns {JSX.Element} The rendered component.
 */
const SimulationForm = ({ onSubmit, onClose, initialValues = {} }) => {
    const { register, handleSubmit, setValue, formState: { errors, isSubmitted } } = useForm({
        defaultValues: initialValues,
    });

    useEffect(() => {
        if (isSubmitted) {
            if (errors.name) {
                toast.error("Enter Position", {/* ...style configuration... */});
            }
            if (errors.latitude) {
                toast.error("Enter Latitude", {/* ...style configuration... */});
            }
            if (errors.longitude) {
                toast.error("Enter Longitude", {/* ...style configuration... */});
            }
        }
    }, [isSubmitted, errors]);

    return (
        <form onSubmit={handleSubmit(onSubmit)} className="relative bg-[#0d2f5c7c] rounded-lg shadow py-4 px-6">
            <div className="grid gap-4 mb-4 grid-cols-2">
                <h3 className="text-xl my-8 font-semibold text-slate-200 col-span-2">Add New Location</h3>
                <div className="col-span-2">
                    <label htmlFor="name" className="block mb-2 text-sm font-medium text-slate-300">Position</label>
                    <input
                        type="text"
                        id="name"
                        className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:outline-none"
                        placeholder="Eiffel Tower, Paris, France"
                        {...register("name", { required: true })}
                    />
                </div>
                <div className="col-span-2">
                    <label htmlFor="address" className="block mb-2 text-sm font-medium text-slate-300">Address</label>
                    <input
                        type="text"
                        id="address"
                        className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:outline-none"
                        placeholder="0x13c857...a2297d22256"
                        {...register("address", { required: true })}
                    />
                </div>
                <div className="col-span-1">
                    <label htmlFor="latitude" className="block mb-2 text-sm font-medium text-slate-300">Latitude</label>
                    <input
                        type="text"
                        id="latitude"
                        className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:ring-sky-950 focus:border-sky-950 focus:outline-none"
                        placeholder="48.8584° N"
                        {...register("latitude", { required: true })}
                    />
                </div>
                <div className="col-span-1">
                    <label htmlFor="longitude" className="block mb-2 text-sm font-medium text-slate-300">Longitude</label>
                    <input
                        type="text"
                        id="longitude"
                        className="bg-sky-950 border border-sky-900 text-gray-100 text-sm rounded-lg block w-full p-2.5 placeholder-slate-400 text-red focus:ring-sky-950 focus:border-sky-950 focus:outline-none"
                        placeholder="2.2945° E"
                        {...register("longitude", { required: true })}
                    />
                </div>
            </div>
            <div className="flex justify-end mt-14">
                <button type="submit" className="mr-4 text-white inline-flex items-center bg-blue-700 hover:bg-blue-800 focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center">Submit</button>
                <button type="button" className="text-white inline-flex items-center bg-[#912020] hover:bg-[#5c1c1c] focus:outline-none font-medium rounded-lg text-sm px-5 py-2.5 text-center" onClick={onClose}>Close</button>
            </div>
        </form>
    );
};

export default SimulationForm;
