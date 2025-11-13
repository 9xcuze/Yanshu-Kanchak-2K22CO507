import { render, screen } from '@testing-library/react';
import Home from '../pages/index';
test('renders feed header', ()=> {
  render(<Home />);
  expect(screen.getByText(/Boostly Feed/i)).toBeInTheDocument();
});
