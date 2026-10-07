# Incident Postmortem: Physical WAN Failure & Interface Transposition

**Date:** 2026-10-05
**Target Device:** Firewall Gateway (Network-001)
**Impact:** Total loss of network ingress, local DHCP, and DNS resolution across all client LAN subnets
**Recovery / resolution time:** ~2 hours

## Summary

Following an electrical surge into the primary WAN port of the firewall, dependent core services (DNS, DHCP) failed to bind, severing all downstream client connectivity. Attempting to bypass the destroyed port by remapping ingress to a LAN interface triggered licensing, factory reset, and interface-mapping anomalies. The system was successfully recovered by forcing a clean factory reset, re-provisioning the license via an alternate interface, and accounting for a physical-to-logical port ID shift caused by the degraded hardware.

## Root Cause

**1.​ WAN Surge:** An electrical surge physically disabled the controller on the network hardware's primary interface.

**2.​ Software Crash:** DHCP and DNS services bound directly to the primary WAN interface state crashed into a failed state, blocking local subnets from acquiring leases or route configurations.

**3. Recovery Port Transpositions:** Resets to disable the primary physical WAN port caused the physical port IDs to shift downward by 1 (Port 3 in UI was mapped to physical Port 2).

## Timeline

**(+0 time):** 0820hrs UTC

### Phase 1: Initial Ingress Bypass (+0 to +20m)

Information received to resume progress. Connected serial console to discover DNS and DHCP daemons in failed status due to running dhcpdump processes on the dead interface. Manually brought down interfaces and configured static IP/route parameters to temporarily restore WAN connectivity through an undamaged LAN port.

### Phase 2: Factory Reset & License Re-establishment (+20m to +65m)

Initiated a factory reset to unbind failed services from the dead WAN port. The device experienced licensing verification timeouts due to expecting registration traffic on the primary WAN port. Executed a hard reset and accessed the un-licensed device recovery interface to complete a full factory reset.

### Phase 3: Service Restoration (+65m to +85m)

Re-established vendor licensing using LAN ingress port. Confirmed DNS and DHCP daemons transitioned back to running status, restoring IP assignments and internet routes to clients.

### Post-Recovery Anomaly Resolution (+85 min to +115m)

Discovered anomaly during further testing where physical port IDs were being shifted by -1 due to the unmapped WAN interface. Adjusted physical patching accordingly (left physical Port 1 unassigned, physical Port 2 mapped to logical Port 3, etc).

## Post Incident Actions and Preventions

* **Hardware Surges:** Surge protection installed prior to ingress termination point.
* **Manufacturer:** Contacted about the WAN failure and port offsets.

---

Written by Lachlan Christie.

