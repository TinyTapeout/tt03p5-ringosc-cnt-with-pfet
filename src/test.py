import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_ringosc_cnt(dut):
    dut._log.info("start")

    dut._log.info("reset")
    dut.stop_i.value = 1
    dut.reset_i.value = 1
    dut.shift_i.value = 0
    await Timer(10, units="ns")

    dut._log.info("start oscillating")
    dut.stop_i.value = 0
    dut.reset_i.value = 0
    await Timer(10, units="ns")
    assert int(dut.cnt_o.value) == 5

    dut._log.info("stop oscillating")
    dut.stop_i.value = 1
    await Timer(10, units="ns")
    assert (
        int(dut.cnt_o.value) == 6
    )  # the signal is still oscillating for one more counter cycle

    dut._log.info("resume oscillating")
    dut.stop_i.value = 0
    await Timer(10, units="ns")
    assert int(dut.cnt_o.value) == 11

    dut._log.info("reset the counter, while still oscillating")
    dut.reset_i.value = 1
    await Timer(10, units="ns")
    assert int(dut.cnt_o.value) == 0

    dut._log.info("start counting again")
    dut.reset_i.value = 0
    await Timer(10, units="ns")
    assert int(dut.cnt_o.value) == 5

    await Timer(100, units="ns")
    assert int(dut.cnt_o.value) >= 50 and int(dut.cnt_o.value) <= 70

    unshifted_value = int(dut.cnt_o.value)

    dut._log.info("test shifting")
    dut.shift_i.value = 2
    await Timer(1, units="ps")
    assert int(dut.cnt_o.value) == unshifted_value >> 2

    dut.shift_i.value = 4
    await Timer(1, units="ps")
    assert int(dut.cnt_o.value) == unshifted_value >> 4

    dut.shift_i.value = 0
    await Timer(1, units="ps")
    assert int(dut.cnt_o.value) == unshifted_value

    dut._log.info("all good!")
