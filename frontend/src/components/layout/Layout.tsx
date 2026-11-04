import { Link, Outlet, useNavigate } from 'react-router-dom';
import Header from './header/Header';
import Footer from './footer/Footer';

function Layout() {
    const nav = useNavigate();
    return (
        <>
            <Header onRegisterClick={() => nav('/reg')}/>
            <Outlet/>
            <Footer />
        </>
    )
}

export default Layout;