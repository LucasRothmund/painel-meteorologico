-- Public weather forecasts are intentionally readable without signing in.
-- Keep write access governed by the existing INSERT/UPDATE/DELETE policies.
grant select on table public.weather_forecasts to anon, authenticated;

drop policy if exists "weather_forecasts_public_read" on public.weather_forecasts;
create policy "weather_forecasts_public_read"
  on public.weather_forecasts
  for select
  to anon, authenticated
  using (true);
